require 'csv'

#read the csv file into array of array


# class trade
#    {
#         call: 
#          errata:
#          part-profit:
#          full_profit:
#          stoploss:
#    }

#    class  update{
#            date:
#            time:
#            buy:
#            stoploss/exit:
#            target:
#            part_profit:
#            full_profit:
#            final:
#			 trade_complete
#     }

class Trade 
public
	attr_accessor :complete, :buy, :sel, :date
	@complete
	@buy
	@sell
	@date
end


class SMS_obj 
	attr_accessor :type, :status, :sender, :time, :message
  def initialize(type, status, sender, res1, res2, time, res3, message)
    @type		= type
    @status		= status
	@sender		= sender 
    @time		= time
	@message	= message
  end
	def getMessage()
		@message
	end
end

class Call
	attr_accessor :type, :update, :buy_or_sell
	@type  			    #:INDEX_NSEFUT, :NSEFUT, :CALL, :PUT, :INDEX. :NONE
	@update				#:NEW_TRADE, :UPDATE_BPP, :UPDATE_FP, :UPDATE_EXIT, :UPDATE_STOPLOSS, :NONE
	@buy_or_sell		#:BUY, :SELL
end

def getCallInfo(string)
# if string contains NSEFUT, its a NSE FUTURE CALL
	call = Call.new();
	if(string =~ /Index Call/i && string =~ /NSEFUT/i && !(string =~/BANKNIFTY/ || string =~ /PE/ || string =~ /CE/))
		call.type = :INDEX_NSEFUT;
		call.buy_or_sell = string =~ /buy/i ? :BUY : :NONE;
		call.buy_or_sell = string =~ /sell/i ? :SELL: :NONE;
	elsif(string =~ /Update/i && string =~/nifty/i && !(string =~/BANKNIFTY/ || string =~ /PUT/i || string =~/Bank nifty/i))
		#update, book full profit, nifty, NSEFUT ---
		call.type = :INDEX_NSEFUT;
		call.buy_or_sell = string =~ /buy/i ? :BUY : :LAST;
		call.buy_or_sell = string =~ /sell/i ? :SELL: :LAST;
	else
		call.type = :NONE;	
	end	
	return call;
end

SMS_array_reverse = CSV.read("bkp.csv");

SMS_array = SMS_array_reverse.reverse();

i = 0;		
SMS_obj_array = Array.new();
SMS_array.each do |sms| 
	SMS_obj_array[i] = SMS_obj.new(sms[0], sms[1], sms[2], sms[3], sms[4], sms[5], sms[6], sms[7]);	
	i = i + 1;
end

i=0;

SMS_obj_array.each do |sms|
	call = getCallInfo(sms.message);
	if(call.type == :INDEX_NSEFUT) 
		puts "#{sms.message}\n"	
	end		
		
end
