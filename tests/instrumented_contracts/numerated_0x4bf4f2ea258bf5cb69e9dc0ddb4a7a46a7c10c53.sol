1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     return a / b;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39   mapping(address => uint256) balances;
40   uint256 totalSupply_;
41 
42   function totalSupply() public view returns (uint256) {
43     return totalSupply_;
44   }
45 
46   function transfer(address _to, uint256 _value) public returns (bool) {
47     require(_to != address(0));
48     require(_value <= balances[msg.sender]);
49 
50     balances[msg.sender] = balances[msg.sender].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     emit Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56   function balanceOf(address _owner) public view returns (uint256) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 contract ERC20 is ERC20Basic {
63   function allowance(address owner, address spender)
64     public view returns (uint256);
65 
66   function transferFrom(address from, address to, uint256 value)
67     public returns (bool);
68 
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(
71     address indexed owner,
72     address indexed spender,
73     uint256 value
74   );
75 }
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) internal allowed;
80 
81   function transferFrom(
82     address _from,
83     address _to,
84     uint256 _value
85   )
86     public
87     returns (bool)
88   {
89     require(_to != address(0));
90     require(_value <= balances[_from]);
91     require(_value <= allowed[_from][msg.sender]);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96     emit Transfer(_from, _to, _value);
97     return true;
98   }
99   function approve(address _spender, uint256 _value) public returns (bool) {
100     allowed[msg.sender][_spender] = _value;
101     emit Approval(msg.sender, _spender, _value);
102     return true;
103   }
104   function allowance(
105     address _owner,
106     address _spender
107    )
108     public
109     view
110     returns (uint256)
111   {
112     return allowed[_owner][_spender];
113   }
114   function increaseApproval(
115     address _spender,
116     uint _addedValue
117   )
118     public
119     returns (bool)
120   {
121     allowed[msg.sender][_spender] = (
122       allowed[msg.sender][_spender].add(_addedValue));
123     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124     return true;
125   }
126   function decreaseApproval(
127     address _spender,
128     uint _subtractedValue
129   )
130     public
131     returns (bool)
132   {
133     uint oldValue = allowed[msg.sender][_spender];
134     if (_subtractedValue > oldValue) {
135       allowed[msg.sender][_spender] = 0;
136     } else {
137       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
138     }
139     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143 }
144 
145 contract Ownable {
146   address public owner;
147 
148 
149   event OwnershipRenounced(address indexed previousOwner);
150   event OwnershipTransferred(
151     address indexed previousOwner,
152     address indexed newOwner
153   );
154 
155   constructor() public {
156     owner = msg.sender;
157   }
158   modifier onlyOwner() {
159     require(msg.sender == owner);
160     _;
161   }
162   function renounceOwnership() public onlyOwner {
163     emit OwnershipRenounced(owner);
164     owner = address(0);
165   }
166 
167   function transferOwnership(address _newOwner) public onlyOwner {
168     _transferOwnership(_newOwner);
169   }
170   function _transferOwnership(address _newOwner) internal {
171     require(_newOwner != address(0));
172     emit OwnershipTransferred(owner, _newOwner);
173     owner = _newOwner;
174   }
175 }
176 
177 contract MintableToken is StandardToken, Ownable {
178   event Mint(address indexed to, uint256 amount);
179   event MintFinished();
180 
181   bool public mintingFinished = false;
182 
183 
184   modifier canMint() {
185     require(!mintingFinished);
186     _;
187   }
188 
189   modifier hasMintPermission() {
190     require(msg.sender == owner);
191     _;
192   }
193   function mint(
194     address _to,
195     uint256 _amount
196   )
197     hasMintPermission
198     canMint
199     public
200     returns (bool)
201   {
202     totalSupply_ = totalSupply_.add(_amount);
203     balances[_to] = balances[_to].add(_amount);
204     emit Mint(_to, _amount);
205     emit Transfer(address(0), _to, _amount);
206     return true;
207   }
208   function finishMinting() onlyOwner canMint public returns (bool) {
209     mintingFinished = true;
210     emit MintFinished();
211     return true;
212   }
213 }
214 
215 contract RapidsToken is MintableToken {
216     string public constant name = "Rapids";
217     string public constant symbol = "RPD";
218     uint8 public constant decimals = 18;
219 }