1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, reverts on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     uint256 c = a * b;
17     require(c / a == b);
18 
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     require(b > 0); // Solidity only automatically asserts when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two numbers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 }
53 
54 contract Plus50 {
55     
56     using SafeMath for uint;
57     
58     mapping (address=>uint) public holding;
59     mapping (address=>uint) public percentage;
60     mapping (address=>uint) public time_stamp;
61     
62     address public marketing_wallet = 0x82770c9dE54e316a9eba378516A3314Bc17FAcbe;
63     uint public marketing_percent = 8;
64     
65     uint public max_contribution = 0.5 ether;
66     uint public max_percentage = 150; //150%
67     uint public referral_percent = 2; //2%
68     uint public hourly_percentage = 3125; //0.3125 % per hours
69     uint public payment_delay = 1 hours;
70     uint public count_investors = 0;
71     
72     function bytesToAddress(bytes _data) internal pure returns(address referrer) {
73         assembly {
74             referrer := mload(add(_data,0x14))
75         }
76         
77         return referrer;
78     }
79     
80     function elapsedTime()public view returns(uint) {
81         return now.sub(time_stamp[msg.sender]).div(payment_delay);
82     }
83     
84     function getBonus(uint _value)public pure  returns(uint) {
85         uint bonus = 0;
86         if(_value >= 10 ether && _value < 25 ether){
87             bonus = _value.mul(5).div(1000);
88         }else if(_value >= 25 ether && _value < 50 ether){
89             bonus = _value.mul(75).div(10000);
90         }else if(_value == 50 ether){
91             bonus = _value.mul(1).div(100);
92         }
93         
94         return bonus;
95     }
96     
97     function deposit() internal {
98         uint sum_hold = holding[msg.sender].add(msg.value);
99         
100         require(sum_hold <= max_contribution, 'Maximum Deposit 50 ether');
101         
102         if(holding[msg.sender] > 0 && elapsedTime() > 0){
103             pickUpCharges();
104         }
105         if (msg.data.length == 20) {
106             address referral = bytesToAddress(bytes(msg.data));
107             if(referral != msg.sender){
108                 referral.transfer(msg.value.mul(referral_percent).div(100));
109             }
110             
111         }
112         if(holding[msg.sender] == 0){
113             count_investors+=1;
114         }
115         marketing_wallet.transfer(msg.value.mul(marketing_percent).div(100));
116         holding[msg.sender]+= msg.value.add(getBonus(msg.value));
117         time_stamp[msg.sender] = now;
118     }
119     
120     function pickUpCharges() internal {
121         uint hours_passed = elapsedTime();
122         
123         require(hours_passed > 0, 'You can receive payment 1 time per hour');
124         
125         uint value = (holding[msg.sender].mul(hourly_percentage).div(1000000)).mul(hours_passed);
126         uint total_percent = percentage[msg.sender].add(value);
127         uint max_percent = holding[msg.sender].mul(max_percentage).div(100);
128         if(total_percent > max_percent){
129             uint rest = total_percent - max_percent;
130             holding[msg.sender] = 0;
131             time_stamp[msg.sender] = 0;
132             percentage[msg.sender] = 0;
133             msg.sender.transfer(total_percent.sub(rest));
134         }else{
135             percentage[msg.sender] += value;
136             time_stamp[msg.sender] = now;
137             msg.sender.transfer(value);
138         }
139     }
140     
141     function reinvest()internal {
142         uint hours_passed = elapsedTime();
143         require(holding[msg.sender] > 0  && hours_passed > 0);
144         uint value = (holding[msg.sender].mul(hourly_percentage).div(1000000)).mul(hours_passed);
145         marketing_wallet.transfer(value.mul(marketing_percent).div(100));
146         holding[msg.sender] += value;
147         time_stamp[msg.sender] = now;
148     }
149 
150     function() external payable {
151         if(msg.value > 0){
152             if(msg.value == 0.0000000001 ether){
153                 reinvest();
154             }else{
155                 deposit();
156             }
157         }else if(msg.value == 0){
158             require(holding[msg.sender] > 0);
159             pickUpCharges();
160         }
161     }
162 }