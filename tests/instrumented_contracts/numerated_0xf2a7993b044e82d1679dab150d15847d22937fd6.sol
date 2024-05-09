1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     
5     function multiplication(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14   // integer division of two numbers, truncating the quotient
15   function division(uint256 a, uint256 b) internal pure returns (uint256) {
16     return a / b;
17   }
18 
19   // subtracts two numbers , throws an overflow
20   function subtraction(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function addition(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 /**
33 ownable contract has an owner address & provides basic authorization control
34 functions, this simplifies the implementation of the user permission
35 **/
36 
37 contract Ownable {
38   address public owner;
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41   // constructor sets the original owner of the contract to the sender account
42   constructor() public {
43     owner = msg.sender;
44   }
45 
46   // throws if called by any account other than the owner
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   /**
53   allows the current owner to transfer control of the contract to a new owner
54   newOwner: the address to transfer ownership to
55   **/
56   function transferOwnership(address newOwner) public onlyOwner {
57     require(newOwner != address(0));
58     emit OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61 }
62 
63 // ERC20 basic interface
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address who) public view returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public view returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 // basic version of standard token with no allowances
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81   mapping(address => uint256) balances;
82   uint256 totalSupply_;
83 
84   // total numbers of tokens in existence
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   _to: address to transfer to
91   _value: amoutn to be transferred
92   **/
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[msg.sender]);
96 
97     balances[msg.sender] = balances[msg.sender].subtraction(_value);
98     balances[_to] = balances[_to].addition(_value);
99     emit Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   gets the balance of the specified address
105   _owner: address to query the balance of
106   return: uint256 representing the amount owned by the passed address
107   **/
108   function balanceOf(address _owner) public view returns (uint256) {
109     return balances[_owner];
110   }
111 }
112 
113 contract StandardToken is ERC20, BasicToken {
114   mapping(address => mapping (address => uint256)) internal allowed;
115 
116   /**
117   transfers tokens from one address to another
118   _from address: address which you want to send tokens from
119   _to address: address which you want to transfer to
120   _value uint256: amount of tokens to be transferred
121   **/
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].subtraction(_value);
128     balances[_to] = balances[_to].addition(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].subtraction(_value);
130 
131     emit Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136   approve the passed address to spend the specific amount of tokens on behalf of msg.sender
137   _spender: address which will spend the funds
138   _value: amount of tokens to be spent
139   **/
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     emit Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147   to check the amount of tokens that an owner allowed to a _spender
148   _owner address: address which owns the funds
149   _spender address: address which will spend the funds
150   return: specifying the amount of tokens still available for the spender
151   **/
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 
156   /**
157   increase amount of tokens that an owner allowed to a _spender
158   _spender: address which will spend the funds
159   _addedValue:  amount of tokens to increase the allowance by
160   **/
161   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].addition(_addedValue);
163     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
168     uint oldValue = allowed[msg.sender][_spender];
169 
170     if (_subtractedValue > oldValue) {
171       allowed[msg.sender][_spender] = 0;
172     } else {
173       allowed[msg.sender][_spender] = oldValue.subtraction(_subtractedValue);
174     }
175     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 }
179 
180 contract Configurable {
181   uint256 public constant cap = 1000000*10**18;
182   uint256 public constant basePrice = 100*10**18; // tokens per 1 ETH
183   uint256 public tokensSold = 0;
184 
185   uint256 public constant tokenReserve = 1000000*10**18;
186   uint256 public remainingTokens = 0;
187 }
188 
189 contract CrowdSaleToken is StandardToken, Configurable, Ownable {
190   // enum of current crowdSale state
191   enum Stages {
192     none,
193     icoStart,
194     icoEnd
195   }
196 
197   Stages currentStage;
198 
199   // constructor of CrowdSaleToken
200   constructor() public {
201     currentStage = Stages.none;
202     balances[owner] = balances[owner].addition(tokenReserve);
203     totalSupply_ = totalSupply_.addition(tokenReserve);
204     remainingTokens = cap;
205     emit Transfer(address(this), owner, tokenReserve);
206   }
207 
208   // fallback function to send ether too for CrowdSale
209   function() public payable {
210     require(currentStage == Stages.icoStart);
211     require(msg.value > 0);
212     require(remainingTokens > 0);
213 
214     uint256 weiAmount = msg.value; // calculate tokens to sell
215     uint256 tokens = weiAmount.multiplication(basePrice).division(1 ether);
216     uint256 returnWei = 0;
217 
218     if(tokensSold.addition(tokens) > cap) {
219       uint256 newTokens = cap.subtraction(tokensSold);
220       uint256 newWei = newTokens.division(basePrice).multiplication(1 ether);
221       returnWei = weiAmount.subtraction(newWei);
222       weiAmount = newWei;
223       tokens = newTokens;
224     }
225 
226     tokensSold = tokensSold.addition(tokens); // increment raised amount
227     remainingTokens = cap.subtraction(tokensSold);
228 
229     if(returnWei > 0) {
230       msg.sender.transfer(returnWei);
231       emit Transfer(address(this), msg.sender, returnWei);
232     }
233 
234     balances[msg.sender] = balances[msg.sender].addition(tokens);
235     emit Transfer(address(this), msg.sender, tokens);
236     totalSupply_ = totalSupply_.addition(tokens);
237     owner.transfer(weiAmount); // send money to owner
238     }
239 
240     // starts the ICO
241     function startIco() public onlyOwner {
242       require(currentStage != Stages.icoEnd);
243       currentStage = Stages.icoStart;
244     }
245 
246     // ends the ICO
247     function endIco() internal {
248       currentStage = Stages.icoEnd;
249       // transfer any remaining tokens
250       if(remainingTokens > 0) {
251         balances[owner] = balances[owner].addition(remainingTokens);
252       }
253       // transfer any remaining ETH to the owner
254       owner.transfer(address(this).balance);
255     }
256 
257     // finishes the ICO
258     function finalizeIco() public onlyOwner {
259       require(currentStage != Stages.icoEnd);
260       endIco();
261     }
262 }
263 // Contract to create the token
264 contract MementoToken is CrowdSaleToken {
265   string public constant name = "Memento";
266   string public constant symbol = "MTX";
267   uint32 public constant decimals = 18;
268 }