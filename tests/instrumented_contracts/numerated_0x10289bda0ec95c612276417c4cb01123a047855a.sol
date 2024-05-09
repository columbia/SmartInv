1 /**
2  * Copyright 2018 Bix Foundation.
3  */
4 
5 pragma solidity ^0.4.16;
6 
7 contract owned {
8     address public owner;
9     function owned() public {
10         owner = msg.sender;
11     }
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a / b;
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
46 
47 contract TokenERC20 {
48     using SafeMath for uint;
49     uint256 public totalSupply;
50     mapping (address => uint256) public balanceOf;
51     mapping (address => mapping (address => uint256)) public allowance;
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Burn(address indexed from, uint256 value);
54 
55     function _transfer(address _from, address _to, uint _value) internal {
56         require(_to != 0x0);
57         require(balanceOf[_to] + _value > balanceOf[_to]);
58         uint previousBalances = balanceOf[_from] + balanceOf[_to];
59         balanceOf[_from] = balanceOf[_from].sub(_value);
60         balanceOf[_to] = balanceOf[_to].add(_value);
61         emit Transfer(_from, _to, _value);
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     function transfer(address _to, uint256 _value) public {
66         _transfer(msg.sender, _to, _value);
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         allowance[_from][msg.sender] =  allowance[_from][msg.sender].sub(_value);
71         _transfer(_from, _to, _value);
72 
73         return true;
74     }
75 
76     function approve(address _spender, uint256 _value) public returns (bool success) {
77         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
78         allowance[msg.sender][_spender] = _value;
79         return true;
80     }
81 
82     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
83         tokenRecipient spender = tokenRecipient(_spender);
84         if (approve(_spender, _value)) {
85             spender.receiveApproval(msg.sender, _value, this, _extraData);
86             return true;
87         }
88     }
89 
90     function burn(uint256 _value) public returns (bool success) {
91         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
92         totalSupply = totalSupply.sub(_value);
93         emit Burn(msg.sender, _value);
94         return true;
95     }
96 
97     function burnFrom(address _from, uint256 _value) public returns (bool success) {
98         balanceOf[_from] = balanceOf[_from].sub(_value);
99         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
100         totalSupply = totalSupply.sub(_value);
101         emit Burn(_from, _value);
102         return true;
103     }
104 }
105 
106 contract BixiToken is owned, TokenERC20 {
107 
108     string public constant name = "BIXI";
109     string public constant symbol = "BIXI";
110     uint8 public constant decimals = 18;
111     uint256 public totalSupply = 3000000000 * 10 ** uint256(decimals);
112     address public lockJackpots;
113 
114     uint public constant NUM_OF_RELEASE_PHASE = 3;
115     uint[4] public LockPercentages = [
116         0,   //0%
117         5,    //5%
118         10,    //10%
119         100      //100%
120     ];
121 
122     uint256 public lockStartTime = 1541001600; 
123     uint256 public lockDeadline = lockStartTime.add(30 days); 
124     uint256 public unLockTime = lockDeadline.add(NUM_OF_RELEASE_PHASE *  30 days); 
125     uint256 public lockRewardFactor = 15; //50%
126 
127     mapping (address => uint256) public lockBalanceOf;
128     mapping (address => uint256) public rewardBalanceOf;
129     function BixiToken() public {
130         balanceOf[msg.sender] = totalSupply;
131     }
132 
133     function transfer(address _to, uint256 _value) public {
134         require(!(lockJackpots != 0x0 && msg.sender == lockJackpots));
135         if (lockJackpots != 0x0 && _to == lockJackpots) {
136             _lockToken(_value);
137         }
138         else {
139             _transfer(msg.sender, _to, _value);
140         }
141     }
142 
143     function _transfer(address _from, address _to, uint _value) internal {
144         require(_to != 0x0);
145 
146         uint lockNumOfFrom = 0;
147         if (lockDeadline >= now ) {
148             lockNumOfFrom = lockBalanceOf[_from];
149         }
150         else if (lockDeadline < now && now < unLockTime && lockBalanceOf[_from] > 0) {
151             uint phase = NUM_OF_RELEASE_PHASE.mul(now.sub(lockDeadline)).div(unLockTime.sub(lockDeadline));
152             lockNumOfFrom = lockBalanceOf[_from].sub(rewardBalanceOf[_from].mul(LockPercentages[phase]).div(100));
153         }
154         
155         require(lockNumOfFrom + _value > lockNumOfFrom);
156         require(balanceOf[_from] >= lockNumOfFrom + _value);
157 
158         balanceOf[_from] = balanceOf[_from].sub(_value);
159         balanceOf[_to] = balanceOf[_to].add(_value);
160         emit Transfer(_from, _to, _value);
161     }
162 
163     function increaseLockReward(uint256 _value) public{
164         require(_value > 0);
165         _transfer(msg.sender, lockJackpots, _value * 10 ** uint256(decimals));
166     }
167 
168     function _lockToken(uint256 _lockValue) internal {
169         require(lockJackpots != 0x0);
170         require(now >= lockStartTime);
171         require(now <= lockDeadline);
172         require(lockBalanceOf[msg.sender] + _lockValue > lockBalanceOf[msg.sender]);
173         require(balanceOf[msg.sender] >= lockBalanceOf[msg.sender] + _lockValue);
174 
175         uint256 _reward = _lockValue.mul(lockRewardFactor).div(100);
176         _transfer(lockJackpots, msg.sender, _reward);
177         rewardBalanceOf[msg.sender] = rewardBalanceOf[msg.sender].add(_reward);
178         lockBalanceOf[msg.sender] = lockBalanceOf[msg.sender].add(_lockValue).add(_reward);
179     }
180 
181     function rewardActivityEnd() onlyOwner public {
182         require(unLockTime < now);
183         _transfer(lockJackpots, owner, balanceOf[lockJackpots]);
184     }
185 
186     function setLockJackpots(address newLockJackpots) onlyOwner public {
187         require(lockJackpots == 0x0 && newLockJackpots != 0x0 && newLockJackpots != owner);
188         lockJackpots = newLockJackpots;
189     }
190 
191     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
192         require(_from != lockJackpots);
193         return super.transferFrom(_from, _to, _value);
194     }
195 
196     function approve(address _spender, uint256 _value) public returns (bool success) {
197         require(msg.sender != lockJackpots);
198         return super.approve(_spender, _value);
199     }
200 
201     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
202         require(msg.sender != lockJackpots);
203         return super.approveAndCall(_spender, _value, _extraData);
204     }
205 
206     function burn(uint256 _value) public returns (bool success) {
207         require(msg.sender != lockJackpots);
208         return super.burn(_value);
209     }
210 
211     function burnFrom(address _from, uint256 _value) public returns (bool success) {
212         require(_from != lockJackpots);
213         return super.burnFrom(_from, _value);
214     }
215 }