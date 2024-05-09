1 pragma solidity ^0.4.13;
2 
3 contract Owned {
4     address public Owner;
5 
6     function Owned() internal {
7         Owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == Owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         Owner = newOwner;
17     }
18 }
19 
20 
21 contract Feed is Owned {
22     uint public basePrice=0.005 ether;
23     uint public k=1;
24     uint public showInterval=15;
25     uint public totalMessages=0;
26 
27     
28     struct Message
29     {
30         string content;
31         uint date;
32         address sender;
33         uint price;
34         uint show_date;
35         uint rejected;
36         string rejected_reason;
37     }    
38     
39     mapping (uint => Message) public messageInfo;
40     
41 
42     /* events */
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45 
46     /* Initializes contract  */
47     function Feed() {
48        
49     }
50 
51     function() public payable {
52         submitMessage("");
53     }    
54     
55     function queueCount() public returns (uint _count) {
56         _count=0;
57         for (uint i=totalMessages; i>0; i--) {
58             if (messageInfo[i].show_date<(now-showInterval) && messageInfo[i].rejected==0) return _count;
59             if (messageInfo[i].rejected==0) _count++;
60         }
61         return _count;
62     }
63     
64     function currentMessage(uint _now) public returns ( uint _message_id, string _content, uint _show_date,uint _show_interval,uint _serverTime) {
65         require(totalMessages>0);
66         if (_now==0) _now=now;
67         for (uint i=totalMessages; i>0; i--) {
68             if (messageInfo[i].show_date>=(_now-showInterval) && messageInfo[i].show_date<_now && messageInfo[i].rejected==0) {
69                 //good    
70                 if (messageInfo[i+1].show_date>0) _show_interval=messageInfo[i+1].show_date-messageInfo[i].show_date; else _show_interval=showInterval;
71                 return (i,messageInfo[i].content,messageInfo[i].show_date,_show_interval,_now);
72             }
73              if (messageInfo[i].show_date<(_now-showInterval)) throw;
74         }
75         throw;
76     }  
77 
78   
79     function submitMessage(string _content) payable public returns(uint _message_id, uint _message_price, uint _queueCount) {
80         require(msg.value>0);
81         if (bytes(_content).length<1 || bytes(_content).length>150) throw;
82         uint total=queueCount();
83         uint _last_Show_data=messageInfo[totalMessages].show_date;
84         if (_last_Show_data==0) _last_Show_data=now+showInterval*2; else {
85             if (_last_Show_data<(now-showInterval)) {
86                 _last_Show_data=_last_Show_data+(((now-_last_Show_data)/showInterval)+1)*showInterval;
87             } else _last_Show_data=_last_Show_data+showInterval; 
88         }
89         uint message_price=basePrice+basePrice*total*k;
90         require(msg.value>=message_price);
91 
92         // add message
93         totalMessages++;
94         messageInfo[totalMessages].date=now;
95         messageInfo[totalMessages].sender=msg.sender;
96         messageInfo[totalMessages].content=_content;
97         messageInfo[totalMessages].price=message_price;
98         messageInfo[totalMessages].show_date=_last_Show_data;
99         
100         // refound
101         if (msg.value>message_price) {
102             uint cashback=msg.value-message_price;
103             sendMoney(msg.sender,cashback);
104         }
105         
106         return (totalMessages,message_price,(total+1));
107     }
108 
109 	function sendMoney(address _address, uint _amount) internal {
110 		require(this.balance >= _amount);
111     	if (_address.send(_amount)) {
112     		Transfer(this,_address, _amount);
113     	}	    
114 	}
115 	
116 	function withdrawBenefit(address _address, uint _amount) onlyOwner public {
117 		sendMoney(_address,_amount);
118 
119 	}
120 	
121     
122 	function setBasePrice(uint _newprice) onlyOwner public returns(uint _basePrice) {
123 		require(_newprice>0);
124 		basePrice=_newprice;
125 		return basePrice;
126 	}    
127 	
128 	function setShowInterval(uint _newinterval) onlyOwner public returns(uint _showInterval) {
129 		require(_newinterval>0);
130 		showInterval=_showInterval;
131 		return showInterval;
132 	}    	
133 	
134 	function setPriceCoeff(uint _new_k) onlyOwner public returns(uint _k) {
135 		require(_new_k>0);
136 		k=_new_k;
137 		return k;
138 	}  
139 
140 	
141 	function rejectMessage(uint _message_id, string _reason) onlyOwner public returns(uint _amount) {
142 		require(_message_id>0);
143 		require(bytes(messageInfo[_message_id].content).length > 0);
144 		require(messageInfo[_message_id].rejected==0);
145     	if (messageInfo[_message_id].show_date>=(now-showInterval) && messageInfo[_message_id].show_date<=now) throw;
146 		messageInfo[_message_id].rejected=1;
147 		messageInfo[_message_id].rejected_reason=_reason;
148 		if (messageInfo[_message_id].sender!= 0x0 && messageInfo[_message_id].price>0) {
149 		    sendMoney(messageInfo[_message_id].sender,messageInfo[_message_id].price);
150 		    return messageInfo[_message_id].price;
151 		} else throw;
152 	}  		
153     
154 }