1 pragma solidity ^0.4.25;
2  
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);  
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     uint c = a / b;
12     return c;
13   }
14 
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint a, uint b) internal returns (uint) {
21     uint c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 
26   function assert(bool assertion) internal {
27     if (!assertion) {
28       throw;
29     }
30   }
31 }
32 
33 
34 contract ERC20Basic {
35   uint public totalSupply;
36   function balanceOf(address who) constant returns (uint);
37   function transfer(address to, uint value);
38   event Transfer(address indexed from, address indexed to, uint value);
39   
40   function allowance(address owner, address spender) constant returns (uint);
41   function transferFrom(address from, address to, uint value);
42   function approve(address spender, uint value);
43   event Approval(address indexed owner, address indexed spender, uint value);
44 }
45 
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint;
49     
50   address public owner;
51   
52   /// This is a switch to control the liquidity
53   bool public transferable = true;
54   
55   mapping(address => uint) balances;
56 
57   //The frozen accounts 
58   mapping (address => bool) public frozenAccount;
59 
60   modifier onlyPayloadSize(uint size) {
61      if(msg.data.length < size + 4) {
62        throw;
63      }
64      _;
65   }
66   
67   modifier unFrozenAccount{
68       require(!frozenAccount[msg.sender]);
69       _;
70   }
71   
72   modifier onlyOwner {
73       if (owner == msg.sender) {
74           _;
75       } else {
76           InvalidCaller(msg.sender);
77           throw;
78         }
79   }
80   
81   modifier onlyTransferable {
82       if (transferable) {
83           _;
84       } else {
85           LiquidityAlarm("The liquidity is switched off");
86           throw;
87       }
88   }
89   
90   /// Emitted when the target account is frozen
91   event FrozenFunds(address target, bool frozen);
92   
93   /// Emitted when a function is invocated by unauthorized addresses.
94   event InvalidCaller(address caller);
95 
96   /// Emitted when some TOKEN coins are burn.
97   event Burn(address caller, uint value);
98   
99   /// Emitted when the ownership is transferred.
100   event OwnershipTransferred(address indexed from, address indexed to);
101   
102   /// Emitted if the account is invalid for transaction.
103   event InvalidAccount(address indexed addr, bytes msg);
104   
105   /// Emitted when the liquity of TOKEN is switched off
106   event LiquidityAlarm(bytes msg);
107   
108   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) unFrozenAccount onlyTransferable {
109     if (frozenAccount[_to]) {
110         InvalidAccount(_to, "The receiver account is frozen");
111     } else {
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         Transfer(msg.sender, _to, _value);
115     } 
116   }
117 
118   function balanceOf(address _owner) view returns (uint balance) {
119     return balances[_owner];
120   }
121 
122   ///@notice `freeze? Prevent | Allow` `target` from sending & receiving TOKEN preconditions
123   ///@param target Address to be frozen
124   ///@param freeze To freeze the target account or not
125   function freezeAccount(address target, bool freeze) onlyOwner public {
126       frozenAccount[target]=freeze;
127       FrozenFunds(target, freeze);
128     }
129   
130   function accountFrozenStatus(address target) view returns (bool frozen) {
131       return frozenAccount[target];
132   }
133   
134   function transferOwnership(address newOwner) onlyOwner public {
135       if (newOwner != address(0)) {
136           address oldOwner=owner;
137           owner = newOwner;
138           OwnershipTransferred(oldOwner, owner);
139         }
140   }
141   
142   function switchLiquidity (bool _transferable) onlyOwner returns (bool success) {
143       transferable=_transferable;
144       return true;
145   }
146   
147   function liquidityStatus () view returns (bool _transferable) {
148       return transferable;
149   }
150 }
151 
152 
153 contract StandardToken is BasicToken {
154 
155   mapping (address => mapping (address => uint)) allowed;
156 
157   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) unFrozenAccount onlyTransferable{
158     var _allowance = allowed[_from][msg.sender];
159 
160     // Check account _from and _to is not frozen
161     require(!frozenAccount[_from]&&!frozenAccount[_to]);
162     
163     balances[_to] = balances[_to].add(_value);
164     balances[_from] = balances[_from].sub(_value);
165     allowed[_from][msg.sender] = _allowance.sub(_value);
166     Transfer(_from, _to, _value);
167   }
168 
169   function approve(address _spender, uint _value) unFrozenAccount {
170     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
171 
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174   }
175 
176   function allowance(address _owner, address _spender) view returns (uint remaining) {
177     return allowed[_owner][_spender];
178   }
179   
180 }
181 
182 
183 contract MusicbackToken is StandardToken {
184     string public name = "Musicback";
185     string public symbol = "MUCB";
186     uint public decimals = 18;
187     /**
188      * CONSTRUCTOR, This address will be : 0x...
189      */
190     function MusicbackToken() {
191         owner = msg.sender;
192         totalSupply = 1 * 10 ** 26;
193         balances[owner] = totalSupply;
194     }
195 
196     function () public payable {
197         revert();
198     }
199 }