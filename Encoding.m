function Encoding

    participantID = input('Enter participant number ');
    
    order = input('Enter session order (ab or ba) ', 's');
        
    for rand = 1:participantID
    randperm(8);
    end
    
    Screen('Preference', 'VisualDebuglevel', 1);
    
    [w1, rect] = Screen('OpenWindow',0,0); 
    [center(1), center(2)] = RectCenter(rect);
    Priority(MaxPriority(w1)); 
    HideCursor(); 
       
    KbCheck;
    WaitSecs(0.1);
    
    % SESSIONS RANDOMIZATION
    if order == 'ab'
        range_lista_grezzo_1 = 8;
        range_lista_1 = randperm(range_lista_grezzo_1);
        range_lista_grezzo_2 = [9 10 11 12 13 14 15 16];
        randidx = randperm(numel(range_lista_grezzo_2));
        range_lista_2 = range_lista_grezzo_2(randidx);
    elseif order == 'ba'
        range_lista_grezzo_2 = 8;
        range_lista_2 = randperm(range_lista_grezzo_2);
        range_lista_grezzo_1 = [9 10 11 12 13 14 15 16];
        randidx = randperm(numel(range_lista_grezzo_1));
        range_lista_1 = range_lista_grezzo_1(randidx);
    end

        nLists = 8;
        nWords = 12; 
        
    Screen('TextFont',w1,'Helvetica');
    Screen('TextSize', w1, 50);
    DrawFormattedText(w1, 'Premi la barra spaziatrice per iniziare', 'center', 'center', 255)
    Screen('Flip',w1);
        % Wait for subject to press spacebar
        
    while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space')) == 1 
                break
            end
    end
    
     for lista = 1:nLists
         
        pair_list = sprintf('%d.txt', range_lista_1(lista));
        stimolo = importdata(pair_list);
        text = [1 2 3 4 5 6 7 8 9 10 11 12];
         
        for parola = 1:nWords
            Screen('DrawLine',w1,255,center(1)-50,center(2),center(1)+50,center(2));
            Screen('DrawLine',w1,255,center(1),center(2)-50,center(1),center(2)+50);
            Screen('Flip', w1);
            
            WaitSecs(1.000);
            
            Screen('TextFont',w1,'Helvetica');
            Screen('TextSize', w1, 100);
            DrawFormattedText(w1, stimolo{text(parola)}, 'center', 'center', 255);
            Screen('Flip', w1);
            
            WaitSecs(1.500);
                   
        end
        
        % for the recall phase you just have to add at the end of each list
        % (ie, here in the for loop) one space for subjects to recall and 
        % then press spacebar to go at the following study list
        
     end
        
     for lista = 1:nLists
         
        pair_list = sprintf('%d.txt', range_lista_2(lista));
        stimolo = importdata(pair_list);
        text = [1 2 3 4 5 6 7 8 9 10 11 12];
         
        for parola = 1:nWords
            Screen('DrawLine',w1,255,center(1)-50,center(2),center(1)+50,center(2));
            Screen('DrawLine',w1,255,center(1),center(2)-50,center(1),center(2)+50);
            Screen('Flip', w1);
            
            WaitSecs(1.000);
            
            Screen('TextFont',w1,'Helvetica');
            Screen('TextSize', w1, 100);
            DrawFormattedText(w1, stimolo{text(parola)}, 'center', 'center', 255);
            Screen('Flip', w1);
            
            WaitSecs(1.500);
        end
    end
     
    Screen('TextFont',w1,'Helvetica');
    Screen('TextSize',w1,50);
    DrawFormattedText(w1, 'FINE', 'center', 'center', 255)
    Screen('Flip',w1);
    WaitSecs(3);
    sca;
    ShowCursor;
    fclose('all');
    Priority(0);
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);  

end