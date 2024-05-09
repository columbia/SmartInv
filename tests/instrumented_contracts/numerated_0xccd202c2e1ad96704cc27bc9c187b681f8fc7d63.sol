1 pragma solidity ^0.4.11;
2 //Math operations with safety checks
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 //creator
52 contract owned{
53     address public Admin;
54     function owned() public {
55         Admin = msg.sender;
56     }
57     modifier onlyAdmin{
58         require(msg.sender == Admin);
59         _;
60     }
61     function transferAdmin(address NewAdmin) onlyAdmin public {
62         Admin = NewAdmin;
63     }
64 }
65 
66 //public
67 contract Erc{
68     using SafeMath for uint;
69     uint public totalSupply;
70     mapping(address => uint) balances;
71     mapping (address => mapping (address => uint)) allowed;
72     mapping (address => bool) public frozenAccount;
73     
74     uint256 public sellPrice;
75     uint256 public buyPrice;
76     
77     function balanceOf(address _in) constant returns (uint);
78     function disqualified(address _from,uint value);
79     function transfer(address _to , uint value);
80     function allowance(address owner, address spender) constant returns (uint);
81     function transferFrom(address from,address to ,uint value);
82     function approve(address spender, uint value);
83     
84     event Approval(address indexed owner, address indexed spender, uint value);
85     event Transfer(address indexed from , address indexed to , uint value);
86     event FrozenFunds(address target, bool frozen);
87     event Disqualified(address targetAD, uint value);
88      
89     modifier onlyPayloadSize(uint size) {
90     if(msg.data.length < size + 4) {throw;}_;
91     }
92     
93     function _transfer(address _from ,address _to, uint _value) onlyPayloadSize(2 * 32) internal {
94     require(!frozenAccount[_from]);                     
95     require(!frozenAccount[_to]);
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     Transfer(msg.sender, _to, _value);
99     }
100 }
101 
102 //function
103 contract StandardToken is Erc,owned{
104     //check if user illicit activity,freezeAccount and back to totalSupply
105     function disqualified(address targetAD, uint _value) onlyAdmin public {
106         require(balances[targetAD] >= _value);  
107         balances[targetAD] -= _value;           
108         totalSupply -= _value;                    
109         Disqualified(msg.sender, _value);
110     }
111     
112     function freezeAccount(address target, bool freeze) onlyAdmin public {
113         frozenAccount[target] = freeze;
114         FrozenFunds(target, freeze);
115     }
116 
117     function balanceOf(address _owner) constant returns (uint balance) {
118     return balances[_owner];
119     }
120     
121     function transfer(address _to, uint256 _value) public {
122     _transfer(msg.sender, _to, _value);
123     }
124   
125     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
126     var _allowance = allowed[_from][msg.sender];
127     balances[_to] = balances[_to].add(_value);
128     balances[_from] = balances[_from].sub(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     }
132     
133     function approve(address _spender, uint _value) {
134     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     }
138     
139     function allowance(address _owner, address _spender) constant returns (uint remaining) {
140     return allowed[_owner][_spender];
141     }
142     
143     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyAdmin public {
144         sellPrice = newSellPrice;
145         buyPrice = newBuyPrice;
146     }
147     
148     function buy() payable public {
149         uint amount = msg.value / buyPrice;              // calculates the amount
150         Transfer(this, msg.sender, amount);              // makes the transfers
151     }
152     
153     function sell(uint256 amount) public {
154         require(this.balance >= amount * sellPrice);     // checks if the contract has enough ether to buy
155         Transfer(msg.sender, this, amount);              // makes the transfers
156         msg.sender.transfer(amount * sellPrice);         // sends ether to the seller. It's important to do this last to avoid recursion attacks
157     }
158 }
159 
160 //contract
161 contract SOC is StandardToken {
162     string public name = "CADT Token";
163     string public symbol = "CADT";
164     uint public decimals = 8;
165     uint public INITIAL_SUPPLY = 50000000000000000; // Initial supply is 500,000,000 SOC
166 
167     function SOC(){
168         totalSupply = INITIAL_SUPPLY;
169         balances[msg.sender] = INITIAL_SUPPLY;
170     }
171 }