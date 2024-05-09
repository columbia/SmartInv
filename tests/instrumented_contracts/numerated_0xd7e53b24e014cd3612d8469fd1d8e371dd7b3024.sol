1 pragma solidity 0.4.16;
2 contract Ownable {
3     address public owner;
4 
5     function Ownable() { //This call only first time when contract deployed by person
6         owner = msg.sender;
7     }
8     modifier onlyOwner() { //This modifier is for checking owner is calling
9         if (owner == msg.sender) {
10             _;
11         } else {
12             revert();
13         }
14 
15     }
16 
17 }
18 
19 contract Mortal is Ownable {
20     
21     function kill() {
22         if (msg.sender == owner)
23             selfdestruct(owner);
24     }
25 }
26 
27 contract Token {
28     uint256 public totalSupply;
29     uint256 tokensForICO;
30     uint256 etherRaised;
31 
32     function balanceOf(address _owner) constant returns(uint256 balance);
33 
34     function transfer(address _to, uint256 _tokens) public returns(bool resultTransfer);
35 
36     function transferFrom(address _from, address _to, uint256 _tokens) public returns(bool resultTransfer);
37 
38     function approve(address _spender, uint _value) returns(bool success);
39 
40     function allowance(address _owner, address _spender) constant returns(uint remaining);
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint _value);
43 }
44 contract Pausable is Ownable {
45   event Pause();
46   event Unpause();
47 
48   bool public paused = false;
49 
50 
51   /**
52    * @dev modifier to allow actions only when the contract IS paused
53    */
54   modifier whenNotPaused() {
55     require(!paused);
56     _;
57   }
58 
59   /**
60    * @dev modifier to allow actions only when the contract IS NOT paused
61    */
62   modifier whenPaused() {
63     require(paused);
64     _;
65   }
66 
67   /**
68    * @dev called by the owner to pause, triggers stopped state
69    */
70   function pause() onlyOwner whenNotPaused {
71     paused = true;
72     Pause();
73   }
74 
75   /**
76    * @dev called by the owner to unpause, returns to normal state
77    */
78   function unpause() onlyOwner whenPaused {
79     paused = false;
80     Unpause();
81   }
82 }
83 contract StandardToken is Token,Mortal,Pausable {
84     
85     function transfer(address _to, uint256 _value) whenNotPaused returns (bool success) {
86         require(_to!=0x0);
87         require(_value>0);
88          if (balances[msg.sender] >= _value) {
89             balances[msg.sender] -= _value;
90             balances[_to] += _value;
91             Transfer(msg.sender, _to, _value);
92             return true;
93         } else { return false; }
94     }
95 
96     function transferFrom(address _from, address _to, uint256 totalTokensToTransfer)whenNotPaused returns (bool success) {
97         require(_from!=0x0);
98         require(_to!=0x0);
99         require(totalTokensToTransfer>0);
100     
101        if (balances[_from] >= totalTokensToTransfer&&allowance(_from,_to)>=totalTokensToTransfer) {
102             balances[_to] += totalTokensToTransfer;
103             balances[_from] -= totalTokensToTransfer;
104             allowed[_from][msg.sender] -= totalTokensToTransfer;
105             Transfer(_from, _to, totalTokensToTransfer);
106             return true;
107         } else { return false; }
108     }
109 
110     function balanceOf(address _owner) constant returns (uint256 balanceOfUser) {
111         return balances[_owner];
112     }
113 
114     function approve(address _spender, uint256 _value) returns (bool success) {
115         allowed[msg.sender][_spender] = _value;
116         Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
121       return allowed[_owner][_spender];
122     }
123 
124     mapping (address => uint256) balances;
125     mapping (address => mapping (address => uint256)) allowed;
126 }
127 contract DIGI is StandardToken{
128     string public constant name = "DIGI";
129     uint8 public constant decimals = 4;
130     string public constant symbol = "DIGI";
131     uint256 constant priceOfToken=1666666666666666;
132     uint256 twoWeeksBonusTime;
133     uint256 thirdWeekBonusTime;
134     uint256 fourthWeekBonusTime;
135     uint256 public deadLine;
136     function DIGI(){
137        totalSupply=980000000000;  //98 Million
138        owner = msg.sender;
139        balances[msg.sender] = (980000000000);
140        twoWeeksBonusTime=now + 2 * 1 weeks;//set time for first two week relative to deploy time
141        thirdWeekBonusTime=twoWeeksBonusTime+1 * 1 weeks;//third week calculate by adding one week by first two week
142        fourthWeekBonusTime=thirdWeekBonusTime+1 * 1 weeks;
143        deadLine=fourthWeekBonusTime+1 *1 weeks;//deadline is after fourth week just add one week
144        etherRaised=0;
145     }
146     /**
147      * @dev directly send ether and transfer token to that account 
148      */
149     function() payable whenNotPaused{
150         require(msg.sender != 0x0);
151         require(msg.value >= priceOfToken);//must be atleate single token price
152         require(now<deadLine);
153         uint bonus=0;
154         if(now < twoWeeksBonusTime){
155             bonus=40;
156         }
157         else if(now<thirdWeekBonusTime){
158           bonus=20;  
159         }
160         else if (now <fourthWeekBonusTime){
161             bonus = 10;
162         }
163         uint tokensToTransfer=((msg.value*10000)/priceOfToken);
164         uint bonusTokens=(tokensToTransfer * bonus) /100;
165         tokensToTransfer=tokensToTransfer+bonusTokens;
166        if(balances[owner] <tokensToTransfer) //check etiher owner can have token otherwise reject transaction and ether
167        {
168            revert();
169        }
170         allowed[owner][msg.sender] += tokensToTransfer;
171         bool transferRes=transferFrom(owner, msg.sender, tokensToTransfer);
172         if (!transferRes) {
173             revert();
174         }
175         else{
176         etherRaised+=msg.value;
177         }
178         
179     }
180     
181     /**
182    * @dev called by the owner to extend deadline relative to last deadLine Time,
183    * to accept ether and transfer tokens
184    */
185    function extendDeadline(uint daysToExtend) onlyOwner{
186        deadLine=deadLine +daysToExtend * 1 days;
187    }
188    
189    /**
190     * To transfer all balace to any account by only owner
191     * */
192     function transferFundToAccount(address _accountByOwner) onlyOwner whenPaused returns(uint256 result){
193         require(etherRaised>0);
194         _accountByOwner.transfer(etherRaised);
195         etherRaised=0;
196         return etherRaised;
197     }
198        /**
199     * To transfer all balace to any account by only owner
200     * */
201     function transferLimitedFundToAccount(address _accountByOwner,uint256 balanceToTransfer) onlyOwner whenPaused {
202         require(etherRaised>0);
203         require(balanceToTransfer<etherRaised);
204         _accountByOwner.transfer(balanceToTransfer);
205         etherRaised=etherRaised-balanceToTransfer;
206     }
207     
208 }