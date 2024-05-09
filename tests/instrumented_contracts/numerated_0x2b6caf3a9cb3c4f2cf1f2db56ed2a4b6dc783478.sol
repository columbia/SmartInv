1 pragma solidity 0.5.0;
2 /*
3 HUBTOKEN Standard ERC20 Tokens
4 */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 contract Ownable {
31   address public owner;
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33   constructor() public {
34     owner = msg.sender;
35   }
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     emit OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 }
46 contract ERC20Basic {
47   uint256 public totalSupply;  
48   function balanceOf(address _owner) public view returns (uint256 balance);  
49   function transfer(address _to, uint256 _amount) public returns (bool success);  
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 contract ERC20 is ERC20Basic {
53   function allowance(address _owner, address _spender) public view returns (uint256 remaining);  
54   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);  
55   function approve(address _spender, uint256 _amount) public returns (bool success);  
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60   mapping(address => uint256) balances;
61   function transfer(address _to, uint256 _amount) public returns (bool success) {
62     require(_to != address(0));
63     require(balances[msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]);
64     balances[msg.sender] = balances[msg.sender].sub(_amount);
65     balances[_to] = balances[_to].add(_amount);
66     emit Transfer(msg.sender, _to, _amount);
67     return true;
68   }
69   function balanceOf(address _owner) public view returns (uint256 balance) {
70     return balances[_owner];
71   }
72 }
73 contract StandardToken is ERC20, BasicToken {  
74   mapping (address => mapping (address => uint256)) internal allowed;
75   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
76     require(_to != address(0));
77     require(balances[_from] >= _amount);
78     require(allowed[_from][msg.sender] >= _amount);
79     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
80     balances[_from] = balances[_from].sub(_amount);
81     balances[_to] = balances[_to].add(_amount);
82     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
83     emit Transfer(_from, _to, _amount);
84     return true;
85   }
86   function approve(address _spender, uint256 _amount) public returns (bool success) {
87     allowed[msg.sender][_spender] = _amount;
88     emit Approval(msg.sender, _spender, _amount);
89     return true;
90   }
91   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
92     return allowed[_owner][_spender];
93   }
94 }
95 contract BurnableToken is StandardToken, Ownable {
96     event Burn(address indexed burner, uint256 value);
97 	function burn(uint256 _value) public onlyOwner{
98         require(_value <= balances[msg.sender]);
99 		balances[msg.sender] = balances[msg.sender].sub(_value);
100         totalSupply = totalSupply.sub(_value);
101         emit Burn(msg.sender, _value);
102     }
103 }
104 contract HUBToken is BurnableToken {
105     string public name = "HUB Token";
106     string public symbol = "HUB";
107     uint256 public totalSupply;
108     uint8 public decimals = 18;
109 	function () external payable  {
110         revert();
111     }	 
112     
113 	constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
114         initialSupply = 1000000000;
115         totalSupply = initialSupply.mul( 10 ** uint256(decimals));
116         tokenName = "HUB Token";
117         tokenSymbol = "HUB";
118         balances[msg.sender] = totalSupply;
119         emit Transfer(address(0), msg.sender, totalSupply);
120     }
121     
122 	function getTokenDetail() public view returns (string memory, string memory, uint256) {
123 	    return (name, symbol, totalSupply);
124     }
125  }