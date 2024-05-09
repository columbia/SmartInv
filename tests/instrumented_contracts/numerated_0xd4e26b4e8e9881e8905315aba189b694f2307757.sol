1 pragma solidity ^0.4.18;
2 
3 /*
4 
5   Copyright 2018 Kotlind Foundation.
6   https://www.ktd.io/
7 
8 */
9 
10 library SafeMath {
11 
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a / b;
23     return c;
24   }
25 
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   function transferOwnership(address newOwner) public onlyOwner {
56     require(newOwner != address(0));
57     OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59   }
60 
61 }
62 
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) public view returns (uint256);
72   function transferFrom(address from, address to, uint256 value) public returns (bool);
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83 
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   function balanceOf(address _owner) public view returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) internal allowed;
106 
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]);
111 
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   function approve(address _spender, uint256 _value) public returns (bool) {
120     allowed[msg.sender][_spender] = _value;
121     Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   function allowance(address _owner, address _spender) public view returns (uint256) {
126     return allowed[_owner][_spender];
127   }
128 
129   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
130     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
131     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
136     uint oldValue = allowed[msg.sender][_spender];
137     if (_subtractedValue > oldValue) {
138       allowed[msg.sender][_spender] = 0;
139     } else {
140       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141     }
142     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146 }
147 
148 contract BurnableToken is BasicToken {
149 
150   event Burn(address indexed burner, uint256 value);
151 
152   function burn(uint256 _value) public {
153     require(_value <= balances[msg.sender]);
154     address burner = msg.sender;
155     balances[burner] = balances[burner].sub(_value);
156     totalSupply_ = totalSupply_.sub(_value);
157     Burn(burner, _value);
158     Transfer(burner, address(0), _value);
159   }
160 }
161 
162 contract Kotlind is StandardToken, BurnableToken, Ownable {
163     // Constants
164     string  public constant name = "Kotlind";
165     string  public constant symbol = "KTD";
166     uint8   public constant decimals = 9;
167     uint256 public constant INITIAL_SUPPLY      = 100000000 * (10 ** uint256(decimals));
168 
169     uint public amountRaised;
170     uint256 public buyPrice = 575;
171     bool public crowdsaleClosed;
172 
173     function Kotlind() public {
174     	totalSupply_ = INITIAL_SUPPLY;
175       balances[msg.sender] = INITIAL_SUPPLY;
176       Transfer(0x0, msg.sender, INITIAL_SUPPLY);
177   	}
178 
179     function _transfer(address _from, address _to, uint _value) internal {     
180         require (balances[_from] >= _value);
181         require (balances[_to] + _value > balances[_to]);
182    
183         balances[_from] -= _value;
184         balances[_to] += _value;
185         Transfer(_from, _to, _value);
186     }
187 
188     function setPrices(bool closebuy, uint256 newBuyPrice) onlyOwner public {
189         crowdsaleClosed=closebuy;
190         buyPrice = newBuyPrice;
191     }
192 
193     function () payable public{
194         require(!crowdsaleClosed);
195         uint amount = msg.value ;
196         amountRaised+=amount;
197         _transfer(owner, msg.sender, amount * buyPrice);
198     }
199 
200     function safeWithdrawal() onlyOwner public {
201        owner.transfer(amountRaised);
202     }
203 
204     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {
205         require( _recipients.length > 0 && _recipients.length == _values.length);
206 
207         uint total = 0;
208         for(uint i = 0; i < _values.length; i++){
209             total = total.add(_values[i]);
210         }
211         require(total <= balances[msg.sender]);
212 
213         for(uint j = 0; j < _recipients.length; j++){
214             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
215             Transfer(msg.sender, _recipients[j], _values[j]);
216         }
217 
218         balances[msg.sender] = balances[msg.sender].sub(total);
219         return true;
220     }
221 }