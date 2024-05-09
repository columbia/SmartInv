1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract owned {
32     address public owner;
33 
34     function owned() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         owner = newOwner;
45     }
46 }
47 
48 contract frozen is owned {
49 
50     mapping (address => bool) public frozenAccount;
51     event FrozenFunds(address target, bool frozen);
52     
53     modifier isFrozen(address _target) {
54         require(!frozenAccount[_target]);
55         _;
56     }
57 
58     function freezeAccount(address _target, bool _freeze) public onlyOwner {
59         frozenAccount[_target] = _freeze;
60         emit FrozenFunds(_target, _freeze);
61     }
62 }
63 
64 
65 contract DDP is frozen{
66     
67     using SafeMath for uint256;
68     uint256 private constant LOCK_PERCENT= 100; 
69     uint256 private constant UN_FREEZE_CYCLE = 30 days;
70     uint256 private constant EVERY_RELEASE_COUNT = 10;
71     uint256 private constant INT100 = 100;
72     
73     
74     string public name;
75     string public symbol;
76     uint8 public decimals = 8;  
77     uint256 public totalSupply;
78    
79     
80     uint256 private startLockTime;
81     
82     mapping (address => uint256) public balanceOf;
83     mapping(address => uint256) freezeBalance;
84     mapping(address => uint256) public preTotalTokens;
85 
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     function DDP() public {
89         totalSupply = 2100000000 * 10 ** uint256(decimals);  
90         balanceOf[msg.sender] = totalSupply;                
91         name = "Distributed Diversion Paradise";                                   
92         symbol = "DDP";                               
93     }
94 
95     function transfer(address _to, uint256 _value) public returns (bool){
96         _transfer(msg.sender, _to, _value);
97         return true;
98     }
99     
100     function _transfer(address _from, address _to, uint _value) internal isFrozen(_from) isFrozen(_to){
101         require(_to != 0x0);
102         require(balanceOf[_from] >= _value);
103         require(balanceOf[_to]+ _value > balanceOf[_to]);
104         if(freezeBalance[_from] > 0){
105             require(now > startLockTime);
106             uint256 percent = (now - startLockTime) / UN_FREEZE_CYCLE * EVERY_RELEASE_COUNT;
107             if(percent <= LOCK_PERCENT){
108                 freezeBalance[_from] = preTotalTokens[_from] * (LOCK_PERCENT - percent) / INT100;
109                 require (_value <= balanceOf[_from] - freezeBalance[_from]); 
110             }else{
111                 freezeBalance[_from] = 0;
112             }
113         } 
114         balanceOf[_from] = balanceOf[_from] - _value;
115         balanceOf[_to] = balanceOf[_to] + _value;
116         emit Transfer(_from, _to, _value);
117     }
118 
119     function lock(address _to, uint256 _value) public onlyOwner isFrozen(_to){
120         _value = _value.mul(10 ** uint256(decimals));
121 		require(balanceOf[owner] >= _value);
122 		require (balanceOf[_to].add(_value)> balanceOf[_to]); 
123 		require (_to != 0x0);
124         balanceOf[owner] = balanceOf[owner].sub(_value);
125         balanceOf[ _to] =balanceOf[_to].add(_value);
126         preTotalTokens[_to] = preTotalTokens[_to].add(_value);
127         freezeBalance[_to] = preTotalTokens[_to].mul(LOCK_PERCENT).div(INT100);
128 	    emit Transfer(owner, _to, _value);
129     }
130     
131     function transfers(address[] _dests, uint256[] _values) onlyOwner public {
132         uint256 i = 0;
133         while (i < _dests.length) {
134             transfer(_dests[i], _values[i]);
135             i += 1;
136         }
137     }
138    
139     function locks(address[] _dests, uint256[] _values) onlyOwner public {
140         uint256 i = 0;
141         while (i < _dests.length) {
142             lock(_dests[i], _values[i]);
143             i += 1;
144         }
145     }
146     
147     function setStartLockTime(uint256 _time) external onlyOwner{
148         startLockTime = _time;
149     }
150     
151     function releaseCount() public view returns(uint256) {
152         if(startLockTime == 0 || startLockTime > now){
153             return 0;
154         }
155         uint256 percent = now.sub(startLockTime).div(UN_FREEZE_CYCLE).add(1);
156         if(percent < INT100.div(EVERY_RELEASE_COUNT)){
157             return percent;
158         }else{
159             return INT100.div(EVERY_RELEASE_COUNT);
160         }
161         
162     }
163 
164 }