function [tf_objects] = calc_the_transfer_function(whisker, calcium_data, Fs, predict_what)


    %for animal_idx = 1:size(whisker,2)
       
        
   
    Ts = 1/Fs; %sample time = time between samples
    if strcmp(predict_what, 'calcium')
        curr_input = whisker;
        curr_output = calcium_data;         
    elseif strcmp(predict_what, 'whisker')
         curr_input = calcium_data;       
         curr_output = whisker;       
    end
    
     
        
    if strcmp(predict_what, 'calcium')      
      
        dataobj1 = iddata(curr_output(:,1), curr_input(:,1), Ts);    
        LL = size(curr_input,1);
        time_length = LL/31;
        ti = linspace(1,time_length, LL); %create time ticks for x-axis    
        Fs = 1/Ts; %sampling frequency
        Fn = Fs/2; %Nyquist frequency        
        tfobj1 = tfest(dataobj1,2,2);        
        tf_objects{1,animal_idx} = tfobj1; 
        
        
     elseif strcmp(predict_what, 'whisker')       
        
        dataobj1 = iddata(curr_output(:,1), curr_input(:,1), Ts); 
        LL = size(curr_input,1);
        time_length = LL/31;
        ti = linspace(1,time_length, LL); %create time ticks for x-axis      
        Fs = 1/Ts; %sampling frequency
        Fn = Fs/2; %Nyquist frequency
        tfobj1 = tfest(dataobj1,2,2);      
        tf_objects = tfobj1;       
        
     else
         
         tf_objects = [];
   
     end
         
   end
    
   
    
