1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     return a / b;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
32 
33 contract Ownable {
34   address public owner;
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     emit OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 contract TokenERC20 is Ownable {
56 
57     using SafeMath for uint256;
58 
59     string public constant name       = "Full tee all";
60     string public constant symbol     = "FTA";
61     uint32 public constant decimals   = 6;
62     uint256 public totalSupply;
63     uint256 public currentTotalSupply = 0;
64     uint256 public airdrop;
65     uint256 public startBalance;
66     uint256 public buyPrice ;
67 
68     mapping(address => bool) touched;
69     mapping(address => uint256) balances;
70     mapping(address => mapping (address => uint256)) internal allowed;
71     mapping(address => bool) public frozenAccount;
72 
73     event FrozenFunds(address target, bool frozen);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76     event Burn(address indexed burner, uint256 value);
77 
78     constructor(
79         uint256 initialSupply
80     ) public {
81         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
82         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
83     }
84 
85     function totalSupply() public view returns (uint256) {
86         return totalSupply;
87     }
88 
89     function transfer(address _to, uint256 _value) public returns (bool) {
90         require(_to != address(0));
91 
92         if( !touched[msg.sender] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop ){
93             balances[msg.sender] = balances[msg.sender].add( startBalance );
94             touched[msg.sender] = true;
95             currentTotalSupply = currentTotalSupply.add( startBalance );
96         }
97 
98         require(!frozenAccount[msg.sender]);
99         require(_value <= balances[msg.sender]);
100 
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         emit Transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108         require(_to != address(0));
109         require(_value <= balances[_from]);
110         require(_value <= allowed[_from][msg.sender]);
111         require(!frozenAccount[_from]);
112 
113         if( !touched[_from] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop  ){
114             touched[_from] = true;
115             balances[_from] = balances[_from].add( startBalance );
116             currentTotalSupply = currentTotalSupply.add( startBalance );
117         }
118 
119         balances[_from] = balances[_from].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122         emit Transfer(_from, _to, _value);
123         return true;
124     }
125 
126 
127     function approve(address _spender, uint256 _value) public returns (bool) {
128         allowed[msg.sender][_spender] = _value;
129         emit Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133     function allowance(address _owner, address _spender) public view returns (uint256) {
134         return allowed[_owner][_spender];
135     }
136 
137     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
138         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140         return true;
141     }
142 
143     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
144         uint oldValue = allowed[msg.sender][_spender];
145         if (_subtractedValue > oldValue) {
146             allowed[msg.sender][_spender] = 0;
147         } else {
148             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
149         }
150         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151         return true;
152     }
153 
154     function getBalance(address _a) internal constant returns(uint256) {
155         if( currentTotalSupply < totalSupply ){
156             if( touched[_a] )
157                 return balances[_a];
158             else
159                 return balances[_a].add( startBalance );
160         } else {
161             return balances[_a];
162         }
163     }
164 
165     function balanceOf(address _owner) public view returns (uint256 balance) {
166         return getBalance( _owner );
167     }
168 
169 
170     function burn(uint256 _value)  public  {
171         _burn(msg.sender, _value);
172     }
173 
174     function _burn(address _who, uint256 _value) internal {
175         require(_value <= balances[_who]);
176         balances[_who] = balances[_who].sub(_value);
177         totalSupply = totalSupply.sub(_value);
178         emit Burn(_who, _value);
179         emit Transfer(_who, address(0), _value);
180     }
181 
182 
183     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
184         balances[target] = balances[target].add(mintedAmount);
185         totalSupply = totalSupply.add(mintedAmount);
186         emit Transfer(0, this, mintedAmount);
187         emit Transfer(this, target, mintedAmount);
188     }
189 
190 
191     function freezeAccount(address target, bool freeze) onlyOwner public {
192         frozenAccount[target] = freeze;
193         emit FrozenFunds(target, freeze);
194     }
195 
196 
197     function setPrices(uint256 newBuyPrice) onlyOwner public {
198         buyPrice = newBuyPrice;
199     }
200 
201     function () payable public {
202         uint amount = msg.value * buyPrice;
203         balances[msg.sender] = balances[msg.sender].add(amount);
204         balances[owner] = balances[owner].sub(amount);
205         emit Transfer(owner, msg.sender, amount);
206     }
207 
208 
209     function selfdestructs() payable  public onlyOwner {
210         selfdestruct(owner);
211     }
212 
213 
214     function getEth(uint num) payable public onlyOwner {
215         owner.transfer(num);
216     }
217 
218 
219     function modifyairdrop(uint256 _airdrop,uint256 _startBalance ) public onlyOwner {
220         airdrop = _airdrop;
221         startBalance = _startBalance;
222     }
223 }