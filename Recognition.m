function Recognition

    participantID = input('Enter subject number ', 's');
    
    randomID = input('Enter randomization number ');
    
    order_ses = input('Enter session order (ab or ba) ', 's');

    condition = input('Enter order of conditions (1 = cedx-cz; 2 = cz-cedx; 3 = behavioral) ', 's');
    
    key_recog = input('Please enter key recognition number (1 = JK; 2 = KJ) ', 's');
    
    %Screen('Preference', 'SkipSyncTests', 1); %evita la sincronizzazione

    KbCheck;
    WaitSecs(0.1);
    GetSecs;

    if condition == '1'
        condition_def = 'cedx-cz';
    elseif condition == '2'
        condition_def = 'cz-cedx';
    elseif condition == '3'
        condition_def = 'behavioral';
    end
    
    filename = ['recognition', '_', participantID, '_', order_ses,'_', condition_def];
    header = {'order', 'order_session', 'session', 'condition', 'word', 'resp_corr', 'resp_resp', 'ACC', 'RTs', 'LURE'};
    sheet = 'Foglio1';
    sheet2 = 'Foglio2';
    xlsRange_intestazione = 'A1';
    
    xlswrite(filename,header,sheet,xlsRange_intestazione);
    xlswrite(filename,header,sheet2,xlsRange_intestazione);
    
    nTrials = 72;
    
    for rand = 1:randomID
    randperm(72);
    end
    
    text = randperm(nTrials);

    % SESSIONS RANDOMIZATION
    if order_ses == 'ab'
    pair_list1 = 'ses_A.txt';
    pair_list2 = 'ses_B.txt';
    stimolo = importdata(pair_list1);
    stimolo2 = importdata(pair_list2);
    session1 = 'a';
    session2 = 'b';
    elseif order_ses == 'ba'
    pair_list1 = 'ses_B.txt';
    pair_list2 = 'ses_A.txt';
    stimolo = importdata(pair_list1);
    stimolo2 = importdata(pair_list2);
    session1 = 'b';
    session2 = 'a';
    end
    
    if condition == '1'
        condition1 = 'cedx';
        condition2 = 'cz';
    elseif condition == '2'
        condition1= 'cz';
        condition2= 'cedx';
    elseif condition == '3'
        condition1= 'behavioral';
        condition2= 'behavioral';
    end
    
    Screen('Preference', 'VisualDebuglevel', 1);
    
    [w1, rect] = Screen('OpenWindow' ,0,0);
    [center(1), center(2)] = RectCenter(rect);
    Priority(MaxPriority(w1));
    HideCursor();
    
        Screen('TextFont',w1,'Helvetica');
        Screen('TextSize',w1,50);
        DrawFormattedText(w1, 'Premi J o K per iniziare', 'center', 'center', 255)
        Screen('Flip',w1);
        % Wait for subject
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('j')) == 1 
                break
            elseif keyCode(KbName('k')) == 1 
                break
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SESSION 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for trial = 1:nTrials   
           % wait a bit between trials
            WaitSecs(0.500);
            
            Screen('DrawLine',w1,255,center(1)-50,center(2),center(1)+50,center(2));
            Screen('DrawLine',w1,255,center(1),center(2)-50,center(1),center(2)+50);
            Screen('Flip', w1);
            clearport;
            WaitSecs(3.000);
            
            Screen('TextFont',w1,'Helvetica');
            Screen('TextSize', w1, 100);
            DrawFormattedText(w1, stimolo{text(trial)}, 'center', 'center', 255);
            Screen('Flip', w1);
            WaitSecs(0.1);
            writeport % trigger tms
            
                        if (text(trial) <= 32) % hits
                            resp_corr = '1';
                        elseif (text(trial) > 32) % rejections
                            resp_corr = '0';
                        end
                        
                        if (text(trial) >= 65) % LURES
                            LURE = 'critical_lure';
                        elseif (text(trial) >= 49 && text(trial) <= 64) % weakly related
                            LURE = 'weakly_related_lure';
                        elseif (text(trial) >= 33 && text(trial) <= 48) % unrelated
                            LURE = 'unrelated_lure';
                        elseif (text(trial) <= 32) % old
                            LURE = 'studied_word';
                        end
                        
                        % KEYS
                        if key_recog == '1'
                            old = KbName('j');
                            new = KbName('k');
                        elseif key_recog == '2'
                            old = KbName('k');
                            new = KbName('j');
                        end
                        
                    targettime = GetSecs;
                    tic;
                    while toc < 10.0
                    [keyIsDown,secs,keyCode] = KbCheck;
                    
                    % ihoe to answer old
                    if keyCode(old) == 1 
                        responsetime = secs;
                        resp_resp = '1';
                        RT_final = responsetime - targettime;
                        
                        if resp_resp == resp_corr
                        ACC = '1';
                        else
                        ACC = '0';
                        end
                        
                        Val_Trial = {trial, order_ses, session1, condition1, stimolo{text(trial)}, resp_corr, resp_resp, ACC, RT_final, LURE};
                        
                        Range = text(trial)+1;
                        Range_Trial = sprintf('A%d',Range);
                    
                        xlswrite(filename,Val_Trial,sheet,Range_Trial);
                        
                        break
                    
                    % how to answer new
                    elseif keyCode(new) == 1
                        responsetime = secs;
                        resp_resp = '0';
                        RT_final = responsetime - targettime;
                        
                        if resp_resp == resp_corr
                        ACC = '1';
                        else
                        ACC = '0';
                        end
                        
                        Val_Trial = {trial, order_ses, session1, condition1, stimolo{text(trial)}, resp_corr, resp_resp, ACC,  RT_final, LURE};
                        
                        Range = text(trial)+1;
                        Range_Trial = sprintf('A%d',Range);
                    
                        xlswrite(filename,Val_Trial,sheet,Range_Trial);
                        
                        break
                                      
                    end
                    end
            
        end % for trial loop
        Screen('Flip',w1);
        Screen('TextFont',w1,'Helvetica');
        Screen('TextSize',w1,50);
        DrawFormattedText(w1, 'STOP', 'center', 'center', 255)
        Screen('Flip',w1);
        WaitSecs(3.000);
        
        Screen('Flip',w1);
        Screen('TextFont',w1,'Helvetica');
        Screen('TextSize',w1,50);
        DrawFormattedText(w1, 'Premi J o K\nquando lo sperimentatore dà il via', 'center', 'center', 255)
        Screen('Flip',w1);
        % Wait for subject
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('j')) == 1 
                break
            elseif keyCode(KbName('k')) == 1 
                break
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SESSION 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for trial = 1:nTrials   
           % wait a bit between trials
            WaitSecs(0.500);
            
            Screen('DrawLine',w1,255,center(1)-50,center(2),center(1)+50,center(2));
            Screen('DrawLine',w1,255,center(1),center(2)-50,center(1),center(2)+50);
            Screen('Flip', w1);
            clearport;
            WaitSecs(3.000);
            
            Screen('TextFont',w1,'Helvetica');
            Screen('TextSize', w1, 100);
            DrawFormattedText(w1, stimolo2{text(trial)}, 'center', 'center', 255);
            Screen('Flip', w1);
            WaitSecs(0.1);
            writeport % trigger tms
            
                        if (text(trial) <= 32) % hits
                            resp_corr = '1';
                        elseif (text(trial) > 32) % rejections
                            resp_corr = '0';
                        end
                        
                        if (text(trial) >= 65) % LURES
                            LURE = 'critical_lure';
                        elseif (text(trial) >= 49 && text(trial) <= 64) % weakly related
                            LURE = 'weakly_related_lure';
                        elseif (text(trial) >= 33 && text(trial) <= 48) % unrelated
                            LURE = 'unrelated_lure';
                        elseif (text(trial) <= 32) % old
                            LURE = 'studied_word';
                        end
                        
                        % KEYS
                        if key_recog == '1'
                            old = KbName('j');
                            new = KbName('k');
                        elseif key_recog == '2'
                            old = KbName('k');
                            new = KbName('j');
                        end
                        
                    targettime = GetSecs;
                    tic;
                    while toc < 10.0
                    [keyIsDown,secs,keyCode] = KbCheck;
                    
                    % how to answer old
                    if keyCode(old) == 1
                        responsetime = secs;
                        resp_resp = '1';
                        RT_final = responsetime - targettime;
                        
                        if resp_resp == resp_corr
                        ACC = '1';
                        else
                        ACC = '0';
                        end
                        
                        Val_Trial = {trial, order_ses, session2, condition2, stimolo2{text(trial)}, resp_corr, resp_resp, ACC, RT_final, LURE};
                        
                        Range = text(trial)+1;
                        Range_Trial = sprintf('A%d',Range);
                    
                        xlswrite(filename,Val_Trial,sheet2,Range_Trial);
                        
                        break
                    
                    % how to answer new
                    elseif keyCode(new) == 1 
                        responsetime = secs;
                        resp_resp = '0';
                        RT_final = responsetime - targettime;
                        
                        if resp_resp == resp_corr
                        ACC = '1';
                        else
                        ACC = '0';
                        end
                        
                        Val_Trial = {trial, order_ses, session2, condition2, stimolo2{text(trial)}, resp_corr, resp_resp, ACC,  RT_final, LURE};
                        
                        Range = text(trial)+1;
                        Range_Trial = sprintf('A%d',Range);
                    
                        xlswrite(filename,Val_Trial,sheet2,Range_Trial);
                        
                        break
                                      
                    end
                    end
        
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('esc')) == 1
                break
            end
            
        end % for trial loop
        
        %end
        Screen('TextFont',w1,'Helvetica');
        Screen('TextSize',w1,50);
        DrawFormattedText(w1, 'FINE', 'center', 'center', 255)
        Screen('Flip',w1);
        WaitSecs(3.000);
    sca;
    ShowCursor;
    fclose('all');
    Priority(0);
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);  

end