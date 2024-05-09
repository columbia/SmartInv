1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.0;
4 
5 
6 
7 // Part: SafeMath
8 
9 library SafeMath {
10 
11     function add(uint a, uint b) internal pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14         return c;
15     }
16 
17     function sub(uint a, uint b) internal pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20         return c;
21     }
22 
23     function mul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32         return c;
33     }
34 
35 }
36 
37 // File: Token.sol
38 
39 /**
40     @title Bare-bones Token implementation
41     @notice Based on the ERC-20 token standard as defined at
42             https://eips.ethereum.org/EIPS/eip-20
43  */
44 contract Token {
45 
46     using SafeMath for uint256;
47 
48     string public symbol;
49     string public name;
50     uint8 public decimals;
51     uint256 public totalSupply;
52 
53     mapping(address => uint256) balances;
54     mapping(address => mapping(address => uint256)) allowed;
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 
59     constructor(
60         string memory _name,
61         string memory _symbol,
62         uint8 _decimals,
63         uint256 _totalSupply
64     )
65         public
66     {
67         name = _name;
68         symbol = _symbol;
69         decimals = _decimals;
70         totalSupply = _totalSupply;
71         balances[msg.sender] = _totalSupply;
72         emit Transfer(address(0), msg.sender, _totalSupply);
73     }
74 
75     /**
76         @notice Getter to check the current balance of an address
77         @param _owner Address to query the balance of
78         @return Token balance
79      */
80     function balanceOf(address _owner) public view returns (uint256) {
81         return balances[_owner];
82     }
83 
84     /**
85         @notice Getter to check the amount of tokens that an owner allowed to a spender
86         @param _owner The address which owns the funds
87         @param _spender The address which will spend the funds
88         @return The amount of tokens still available for the spender
89      */
90     function allowance(
91         address _owner,
92         address _spender
93     )
94         public
95         view
96         returns (uint256)
97     {
98         return allowed[_owner][_spender];
99     }
100 
101     /**
102         @notice Approve an address to spend the specified amount of tokens on behalf of msg.sender
103         @dev Beware that changing an allowance with this method brings the risk that someone may use both the old
104              and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
105              race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
106              https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107         @param _spender The address which will spend the funds.
108         @param _value The amount of tokens to be spent.
109         @return Success boolean
110      */
111     function approve(address _spender, uint256 _value) public returns (bool) {
112         allowed[msg.sender][_spender] = _value;
113         emit Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     /** shared logic for transfer and transferFrom */
118     function _transfer(address _from, address _to, uint256 _value) internal {
119         require(balances[_from] >= _value, "Insufficient balance");
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         emit Transfer(_from, _to, _value);
123     }
124 
125     /**
126         @notice Transfer tokens to a specified address
127         @param _to The address to transfer to
128         @param _value The amount to be transferred
129         @return Success boolean
130      */
131     function transfer(address _to, uint256 _value) public returns (bool) {
132         _transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     /**
137         @notice Transfer tokens from one address to another
138         @param _from The address which you want to send tokens from
139         @param _to The address which you want to transfer to
140         @param _value The amount of tokens to be transferred
141         @return Success boolean
142      */
143     function transferFrom(
144         address _from,
145         address _to,
146         uint256 _value
147     )
148         public
149         returns (bool)
150     {
151         require(allowed[_from][msg.sender] >= _value, "Insufficient allowance");
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153         _transfer(_from, _to, _value);
154         return true;
155     }
156     
157     function increaseAllowance(address _spender, uint256 _value) public returns (bool) {
158         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_value);
159         return true;
160     }
161 
162     function decreaseAllowance(address _spender, uint256 _value) public returns (bool) {
163         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_value);
164         return true;
165     }
166 }
