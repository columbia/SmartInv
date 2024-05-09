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
11   function div(uint256 a, uint256 b) internal pure  returns (uint256) {
12       assert(b > 0);
13       uint256 c = a / b;
14       return c;
15   }
16   function sub(uint256 a, uint256 b) internal pure  returns (uint256) {
17       assert(b <= a);
18       return a - b;
19   }
20   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
21       uint256 c = a + b;
22       assert(c >= a);
23       return c;
24   }
25 }
26 
27 //*************** Ownable ***************
28 
29 contract Ownable {
30   address public owner;
31 
32   function Ownable() public {
33       owner = msg.sender;
34   }
35   modifier onlyOwner() {
36       require(msg.sender == owner);
37       _;
38   }
39   function transferOwnership(address newOwner)public onlyOwner {
40       if (newOwner != address(0)) {
41         owner = newOwner;
42       }
43   }
44 }
45 
46 //************* ERC20 ***************
47 
48 contract ERC20 {
49   function balanceOf(address who)public constant returns (uint256);
50   function transfer(address to, uint256 value)public returns (bool);
51   function transferFrom(address from, address to, uint256 value)public returns (bool);
52   function allowance(address owner, address spender)public constant returns (uint256);
53   function approve(address spender, uint256 value)public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 //************* DoctorChain Token *************
59 
60 contract DoctorChainToken is ERC20,Ownable {
61 	using SafeMath for uint256;
62 
63 	// Token Info.
64 	string public name;
65 	string public symbol;
66 	uint256 public totalSupply;
67 	uint256 public constant decimals = 18;
68 	address[] private walletArr;
69 	uint walletIdx = 0;
70 	mapping (address => uint256) public balanceOf;
71 	mapping (address => mapping (address => uint256)) allowed;
72 	event FundTransfer(address fundWallet, uint256 amount);
73 	function DoctorChainToken( ) public {
74 		name="DoctorChain";
75 		symbol="DCH";
76 		totalSupply = 1000000000*(10**decimals);
77 		balanceOf[msg.sender] = totalSupply;
78 		walletArr.push(0x5Db3F5FD3081Eb6ADdc873ac79B6A7139422d168);
79 	}
80 	function balanceOf(address _who)public constant returns (uint256 balance) {
81 	    return balanceOf[_who];
82 	}
83 	function _transferFrom(address _from, address _to, uint256 _value)  internal {
84 	    require(_to != 0x0);
85 	    require(balanceOf[_from] >= _value);
86 	    require(balanceOf[_to] + _value >= balanceOf[_to]);
87 	    uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
88 	    balanceOf[_from] = balanceOf[_from].sub(_value);
89 	    balanceOf[_to] = balanceOf[_to].add(_value);
90 	    emit Transfer(_from, _to, _value);
91 	    assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
92 	}
93 	function transfer(address _to, uint256 _value) public returns (bool){
94 	    _transferFrom(msg.sender,_to,_value);
95 	    return true;
96 	}
97 	function ()public payable {
98 	    _tokenPurchase( msg.value);
99 	}
100 	function _tokenPurchase( uint256 _value) internal {
101 	    require(_value >= 0.1 ether);
102 	    address wallet = walletArr[walletIdx];
103 	    walletIdx = (walletIdx+1) % walletArr.length;
104 	    wallet.transfer(msg.value);
105 	    emit FundTransfer(wallet, msg.value);
106 	}
107 	function supply()  internal constant  returns (uint256) {
108 	    return balanceOf[owner];
109 	}
110 	function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
111 	    return allowed[_owner][_spender];
112 	}
113 	function approve(address _spender, uint256 _value)public returns (bool) {
114 	    allowed[msg.sender][_spender] = _value;
115 	    emit Approval(msg.sender, _spender, _value);
116 	    return true;
117 	}
118 	function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
119 	    require(_value > 0);
120 	    require (allowed[_from][msg.sender] >= _value);
121 	    require(_to != 0x0);
122 	    require(balanceOf[_from] >= _value);
123 	    require(balanceOf[_to] + _value >= balanceOf[_to]);
124 	    balanceOf[_from] = balanceOf[_from].sub(_value);
125 	    balanceOf[_to] = balanceOf[_to].add(_value);
126 	    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127 	    emit Transfer(_from, _to, _value);
128 	    return true;
129 	  }
130 }