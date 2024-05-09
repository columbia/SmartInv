1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-27
3 */
4 
5 pragma solidity ^0.4.25;
6  
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);  
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     uint c = a / b;
16     return c;
17   }
18 
19   function sub(uint a, uint b) internal returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint a, uint b) internal returns (uint) {
25     uint c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 
30   function assert(bool assertion) internal {
31     if (!assertion) {
32       throw;
33     }
34   }
35 }
36 
37 
38 contract ERC20Basic {
39   uint public totalSupply;
40   function balanceOf(address who) constant returns (uint);
41   function transfer(address to, uint value);
42   event Transfer(address indexed from, address indexed to, uint value);
43   
44   function allowance(address owner, address spender) constant returns (uint);
45   function transferFrom(address from, address to, uint value);
46   function approve(address spender, uint value);
47   event Approval(address indexed owner, address indexed spender, uint value);
48 }
49 
50 
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint;
53     
54   address public owner;
55   
56   /// This is a switch to control the liquidity
57   bool public transferable = true;
58   
59   mapping(address => uint) balances;
60 
61   //The frozen accounts 
62   mapping (address => bool) public frozenAccount;
63 
64   modifier onlyPayloadSize(uint size) {
65      if(msg.data.length < size + 4) {
66        throw;
67      }
68      _;
69   }
70   
71   modifier unFrozenAccount{
72       require(!frozenAccount[msg.sender]);
73       _;
74   }
75   
76   modifier onlyOwner {
77       if (owner == msg.sender) {
78           _;
79       } else {
80           InvalidCaller(msg.sender);
81           throw;
82         }
83   }
84   
85   modifier onlyTransferable {
86       if (transferable) {
87           _;
88       } else {
89           LiquidityAlarm("The liquidity is switched off");
90           throw;
91       }
92   }
93   
94   /// Emitted when the target account is frozen
95   event FrozenFunds(address target, bool frozen);
96   
97   /// Emitted when a function is invocated by unauthorized addresses.
98   event InvalidCaller(address caller);
99 
100   /// Emitted when the ownership is transferred.
101   event OwnershipTransferred(address indexed from, address indexed to);
102   
103   /// Emitted if the account is invalid for transaction.
104   event InvalidAccount(address indexed addr, bytes msg);
105   
106   /// Emitted when the liquity of TOKEN is switched off
107   event LiquidityAlarm(bytes msg);
108   
109  
110   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) unFrozenAccount onlyTransferable {
111     if (frozenAccount[_to]) {
112         InvalidAccount(_to, "The receiver account is frozen");
113     } else {
114         balances[msg.sender] = balances[msg.sender].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         Transfer(msg.sender, _to, _value);
117     } 
118   }
119 
120   function balanceOf(address _owner) view returns (uint balance) {
121     return balances[_owner];
122   }
123 
124   function freezeAccount(address target, bool freeze) onlyOwner public {
125       frozenAccount[target]=freeze;
126       FrozenFunds(target, freeze);
127     }
128   
129   function accountFrozenStatus(address target) view returns (bool frozen) {
130       return frozenAccount[target];
131   }
132   
133   function transferOwnership(address newOwner) onlyOwner public {
134       if (newOwner != address(0)) {
135           address oldOwner=owner;
136           owner = newOwner;
137           OwnershipTransferred(oldOwner, owner);
138         }
139   }
140   
141   function switchLiquidity (bool _transferable) onlyOwner returns (bool success) {
142       transferable=_transferable;
143       return true;
144   }
145   
146   function liquidityStatus () view returns (bool _transferable) {
147       return transferable;
148   }
149  
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
183 contract KorbitToken is StandardToken {
184     string public name = "Korbit";
185     string public symbol = "KBT";
186     uint public decimals = 18;
187     
188     function KorbitToken() {
189         owner = msg.sender;
190         totalSupply = 3000000 * 10 ** 18;
191         balances[owner] = totalSupply;
192     }
193 
194     function () public payable {
195         revert();
196     }
197 }