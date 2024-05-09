1 pragma solidity ^0.5.7;
2 
3 interface ERC20 {
4   function balanceOf(address who) external view returns (uint256);
5   function transfer(address to, uint256 value) external returns (bool);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transferFrom(address from, address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10   event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 interface ERC223 {
14     function transfer(address to, uint value, bytes calldata data) external;
15     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
16 }
17 
18 contract ERC223ReceivingContract { 
19     function tokenFallback(address _from, uint _value, bytes memory _data) public;
20 }
21 
22 /**
23  * @title SafeMath
24  * @dev Unsigned math operations with safety checks that revert on error.
25  */
26 library SafeMath {
27     /**
28      * @dev Multiplies two unsigned integers, reverts on overflow.
29      */
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint256 c = a * b;
39         require(c / a == b);
40 
41         return c;
42     }
43 
44     /**
45      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
46      */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Solidity only automatically asserts when dividing by 0
49         require(b > 0);
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53         return c;
54     }
55 
56     /**
57      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
58      */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b <= a);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Adds two unsigned integers, reverts on overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a);
72 
73         return c;
74     }
75 
76     /**
77      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
78      * reverts when dividing by zero.
79      */
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b != 0);
82         return a % b;
83     }
84 }
85 
86 contract StandardToken is ERC20, ERC223 {
87   uint256 public totalSupply;
88   
89   using SafeMath for uint;
90     
91     mapping (address => uint256) internal balances;
92     mapping (address => mapping (address => uint256)) internal allowed;
93 
94    function transfer(address _to, uint256 _value) public returns (bool) {
95      require(_to != address(0));
96      require(_value <= balances[msg.sender]);
97      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
98      balances[_to] = SafeMath.add(balances[_to], _value);
99      emit Transfer(msg.sender, _to, _value);
100      return true;
101    }
102 
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105    }
106 
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109      require(_value <= balances[_from]);
110      require(_value <= allowed[_from][msg.sender]);
111 
112     balances[_from] = SafeMath.sub(balances[_from], _value);
113      balances[_to] = SafeMath.add(balances[_to], _value);
114      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
115     emit Transfer(_from, _to, _value);
116      return true;
117    }
118 
119    function approve(address _spender, uint256 _value) public returns (bool) {
120      allowed[msg.sender][_spender] = _value;
121      emit Approval(msg.sender, _spender, _value);
122      return true;
123    }
124 
125   function allowance(address _owner, address _spender) public view returns (uint256) {
126      return allowed[_owner][_spender];
127    }
128 
129    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
130      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
131      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132      return true;
133    }
134 
135   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
136      uint oldValue = allowed[msg.sender][_spender];
137      if (_subtractedValue > oldValue) {
138        allowed[msg.sender][_spender] = 0;
139      } else {
140        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
141     }
142      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143      return true;
144    }
145    
146   function transfer(address _to, uint _value, bytes memory _data) public {
147     require(_value > 0 );
148     if(isContract(_to)) {
149         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
150         receiver.tokenFallback(msg.sender, _value, _data);
151     }
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         emit Transfer(msg.sender, _to, _value, _data);
155     }
156     
157   function isContract(address _addr) private returns (bool is_contract) {
158       uint length;
159       assembly {
160             //retrieve the size of the code on target address, this needs assembly
161             length := extcodesize(_addr)
162       }
163       return (length>0);
164     }
165 }
166 
167 contract xbase is StandardToken {
168     string public constant name = "Eterbase Cash";
169     string public constant symbol = "XBASE";
170     uint8 public constant decimals = 18;
171     uint256 public constant initialSupply = 1000000000 * 10 ** uint256(decimals);
172 
173     function xbasecash() public {
174       totalSupply = initialSupply;
175       balances[msg.sender] = initialSupply;
176     }
177 }