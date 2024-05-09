1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 contract Ownable {
29   address public owner;
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31   function Ownable() public {
32     owner = msg.sender;
33   }
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 }
44 contract ERC20Basic {
45   uint256 public totalSupply;  
46   function balanceOf(address _owner) public view returns (uint256 balance);  
47   function transfer(address _to, uint256 _amount) public returns (bool success);  
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 contract ERC20 is ERC20Basic {
51   function allowance(address _owner, address _spender) public view returns (uint256 remaining);  
52   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);  
53   function approve(address _spender, uint256 _amount) public returns (bool success);  
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58   mapping(address => uint256) balances;
59   function transfer(address _to, uint256 _amount) public returns (bool success) {
60     require(_to != address(0));
61     require(balances[msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]);
62     balances[msg.sender] = balances[msg.sender].sub(_amount);
63     balances[_to] = balances[_to].add(_amount);
64     emit Transfer(msg.sender, _to, _amount);
65     return true;
66   }
67   function balanceOf(address _owner) public view returns (uint256 balance) {
68     return balances[_owner];
69   }
70 }
71 contract StandardToken is ERC20, BasicToken {  
72   mapping (address => mapping (address => uint256)) internal allowed;
73   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
74     require(_to != address(0));
75     require(balances[_from] >= _amount);
76     require(allowed[_from][msg.sender] >= _amount);
77     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
78     balances[_from] = balances[_from].sub(_amount);
79     balances[_to] = balances[_to].add(_amount);
80     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
81     emit Transfer(_from, _to, _amount);
82     return true;
83   }
84   function approve(address _spender, uint256 _amount) public returns (bool success) {
85     allowed[msg.sender][_spender] = _amount;
86     emit Approval(msg.sender, _spender, _amount);
87     return true;
88   }
89   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
90     return allowed[_owner][_spender];
91   }
92 }
93 contract BurnableToken is StandardToken, Ownable {
94     event Burn(address indexed burner, uint256 value);
95 	function burn(uint256 _value) public onlyOwner{
96         require(_value <= balances[msg.sender]);
97 		balances[msg.sender] = balances[msg.sender].sub(_value);
98         totalSupply = totalSupply.sub(_value);
99         emit Burn(msg.sender, _value);
100     }
101 }
102 contract FRTToken is BurnableToken {
103     string public name = "FURT COIN";
104     string public symbol = "FRT";
105     uint256 public totalSupply;
106     uint8 public decimals = 18;
107 	function () public payable {
108         revert();
109     }	 
110 	function FRTToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
111         initialSupply = 14360000000;
112         totalSupply = initialSupply.mul( 10 ** uint256(decimals));
113         tokenName = "FURT COIN";
114         tokenSymbol = "FRT";
115         balances[msg.sender] = totalSupply;
116         emit Transfer(address(0), msg.sender, totalSupply);
117     }
118 	function getTokenDetail() public view returns (string, string, uint256) {
119 	    return (name, symbol, totalSupply);
120     }
121  }