1 pragma solidity ^0.4.20;
2 
3 //*************** SafeMath ***************
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
7       uint256 c = a * b;
8       assert(a == 0 || c / a == b);
9       return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure  returns (uint256) {
13       assert(b > 0);
14       uint256 c = a / b;
15       return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure  returns (uint256) {
19       assert(b <= a);
20       return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
24       uint256 c = a + b;
25       assert(c >= a);
26       return c;
27   }
28 }
29 
30 //*************** Ownable *************** 
31 
32 contract Ownable {
33   address public owner;
34   address public admin;
35 
36   constructor() public {
37       owner = msg.sender;
38   }
39 
40   modifier onlyOwner() {
41       require(msg.sender == owner);
42       _;
43   }
44 
45   modifier onlyOwnerAdmin() {
46       require(msg.sender == owner || msg.sender == admin);
47       _;
48   }
49 
50   function transferOwnership(address newOwner)public onlyOwner {
51       if (newOwner != address(0)) {
52         owner = newOwner;
53       }
54   }
55   function setAdmin(address _admin)public onlyOwner {
56       admin = _admin;
57   }
58 
59 }
60 
61 //************* ERC20 *************** 
62 
63 contract ERC20 {
64   
65   function balanceOf(address who)public constant returns (uint256);
66   function transfer(address to, uint256 value)public returns (bool);
67   function transferFrom(address from, address to, uint256 value)public returns (bool);
68   function allowance(address owner, address spender)public constant returns (uint256);
69   function approve(address spender, uint256 value)public returns (bool);
70 
71   event Transfer(address indexed from, address indexed to, uint256 value);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 //************* TWDT Token *************
76 
77 contract TWDTToken is ERC20,Ownable {
78 	using SafeMath for uint256;
79 
80 	// Token Info.
81 	string public name;
82 	string public symbol;
83 	uint256 public totalSupply;
84 	uint256 public constant decimals = 6;
85     bool public needVerified;
86 
87 
88 	mapping (address => uint256) public balanceOf;
89 	mapping (address => mapping (address => uint256)) allowed;
90 	mapping (address => bool) public frozenAccount;
91 	mapping (address => bool) public frozenAccountSend;
92     mapping (address => bool) public verifiedAccount;
93     event FrozenFunds(address target, bool frozen);
94     event FrozenFundsSend(address target, bool frozen);
95     event VerifiedFunds(address target, bool Verified);
96 	event FundTransfer(address fundWallet, uint256 amount);
97 	event Logs(string);
98     event Error_No_Binding_Address(address _from, address _to);
99 
100 	constructor() public {  	
101 		name="Taiwan Digital Token";
102 		symbol="TWDT-ETH";
103 		totalSupply = 100000000000*(10**decimals);
104 		balanceOf[msg.sender] = totalSupply;	
105 	    needVerified = false;
106 	}
107 
108 	function balanceOf(address _who)public constant returns (uint256 balance) {
109 	    return balanceOf[_who];
110 	}
111 
112 	function _transferFrom(address _from, address _to, uint256 _value)  internal {
113 		require(_from != 0x0);
114 	    require(_to != 0x0);
115         // SafeMath 已檢查
116         require(balanceOf[_from] >= _value);
117         require(balanceOf[_to] + _value >= balanceOf[_to]);
118 	    require(!frozenAccount[_from]);                  
119         require(!frozenAccount[_to]); 
120         require(!frozenAccountSend[_from]); 
121         if(!needVerified || (needVerified && verifiedAccount[_from] && verifiedAccount[_to])){
122 
123             uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
124 
125             balanceOf[_from] = balanceOf[_from].sub(_value);
126             balanceOf[_to] = balanceOf[_to].add(_value);
127 
128             emit Transfer(_from, _to, _value);
129 
130             assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
131         } else {
132             emit Error_No_Binding_Address(_from, _to);
133         }
134 	}
135 	
136 	function transfer(address _to, uint256 _value) public returns (bool){	    
137 	    _transferFrom(msg.sender,_to,_value);
138 	    return true;
139 	}
140 	function transferLog(address _to, uint256 _value,string logs) public returns (bool){
141 		_transferFrom(msg.sender,_to,_value);
142 		emit Logs(logs);
143 	    return true;
144 	}
145 	
146 	function ()public {
147 	}
148 
149 
150 	function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
151         require(_spender != 0x0);
152 	    return allowed[_owner][_spender];
153 	}
154 
155 	function approve(address _spender, uint256 _value)public returns (bool) {
156         require(_spender != 0x0);
157 	    allowed[msg.sender][_spender] = _value;
158 	    emit Approval(msg.sender, _spender, _value);
159 	    return true;
160 	}
161 	
162 	function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
163 	    require(_from != 0x0);
164 	    require(_to != 0x0);
165 	    require(_value > 0);
166 	    require(allowed[_from][msg.sender] >= _value);
167 	    require(balanceOf[_from] >= _value);
168 	    require(balanceOf[_to] + _value >= balanceOf[_to]);
169 	    require(!frozenAccount[_from]);                  
170         require(!frozenAccount[_to]);
171         require(!frozenAccountSend[_from]);   
172         if(!needVerified || (needVerified && verifiedAccount[_from] && verifiedAccount[_to])){
173 
174             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
175             balanceOf[_from] = balanceOf[_from].sub(_value);
176             balanceOf[_to] = balanceOf[_to].add(_value);
177             
178             emit Transfer(_from, _to, _value);
179             return true;
180         } else {
181             emit Error_No_Binding_Address(_from, _to);
182             return false;
183         }
184     }
185         
186     function freezeAccount(address _target, bool _freeze)  onlyOwnerAdmin public {
187         require(_target != 0x0);
188         frozenAccount[_target] = _freeze;
189         emit FrozenFunds(_target, _freeze);
190     }
191 
192     function freezeAccountSend(address _target, bool _freeze)  onlyOwnerAdmin public {
193         require(_target != 0x0);
194         frozenAccountSend[_target] = _freeze;
195         emit FrozenFundsSend(_target, _freeze);
196     }
197 
198     function needVerifiedAccount(bool _needVerified)  onlyOwnerAdmin public {
199         needVerified = _needVerified;
200     }
201 
202     function VerifyAccount(address _target, bool _Verify)  onlyOwnerAdmin public {
203         require(_target != 0x0);
204         verifiedAccount[_target] = _Verify;
205         emit VerifiedFunds(_target, _Verify);
206     }
207 
208     function mintToken(address _target, uint256 _mintedAmount) onlyOwner public {
209         require(_target != 0x0);
210         require(_mintedAmount > 0);
211         require(!frozenAccount[_target]);
212         require(totalSupply + _mintedAmount > totalSupply);
213         require(balanceOf[_target] + _mintedAmount > balanceOf[_target]);
214         balanceOf[_target] = balanceOf[_target].add(_mintedAmount);
215         totalSupply = totalSupply.add(_mintedAmount);
216         emit Transfer(0, this, _mintedAmount);
217         emit Transfer(this, _target, _mintedAmount);
218     }
219 
220 
221 	
222 }