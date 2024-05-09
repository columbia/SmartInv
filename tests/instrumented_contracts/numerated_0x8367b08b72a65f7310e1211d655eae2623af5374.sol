1 pragma solidity 0.4.24;
2 
3 /****************************************************************************
4 *                   ******MAJz Token Smart Contract******                   *
5 *                   Symbol      :   MAZ                                     *
6 *                   Name        :   MAJz                                    *
7 *                   Total Supply:   560 000 000                             *
8 *                   Decimals    :   18                                      *
9 *                   Almar Blockchain Technology                             *
10 *                   *************************************                   *
11 ****************************************************************************/
12 
13 
14 /****************************************************************************
15 *                       Safemath Library                                    *
16 *                       to prevent Over / Underflow                         *
17 ****************************************************************************/
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a + b; assert(c >= a); return c; }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) { assert(b <= a); return a - b; }
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         if (a == 0){return 0;} c = a * b; assert(c / a == b); return c; }
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) { return a / b; }
28 }
29 
30 
31 /****************************************************************************
32 *                   Standart ERC20 Token Interface                          *
33 *                   Contains Standart Token Functionalities                 *
34 ****************************************************************************/
35 contract ERC20Token {
36     function totalSupply() public view returns (uint256);
37     function balanceOf(address _targetAddress) public view returns (uint256);
38     function transfer(address _targetAddress, uint256 _value) public returns (bool);
39     event Transfer(address indexed _originAddress, address indexed _targetAddress, uint256 _value);
40     
41     function allowance(address _originAddress, address _targetAddress) public view returns (uint256);
42     function approve(address _originAddress, uint256 _value) public returns (bool);
43     function transferFrom(address _originAddress, address _targetAddress, uint256 _value) public returns (bool);
44     event Approval(address indexed _originAddress, address indexed _targetAddress, uint256 _value);
45 }
46 
47 
48 /****************************************************************************
49 *                       Ownership Contract                                  *
50 *                       for authorization Control                           *
51 ****************************************************************************/
52 contract Ownership {
53     address public owner;
54 
55     modifier onlyOwner() { require(msg.sender == owner); _; }
56     modifier validDestination(address _targetAddress) { require(_targetAddress != address(0x0)); _; }
57 }
58 
59 
60 /****************************************************************************
61 *                       The Token Contract                                  *
62 *                       with Extended funtionalities                        *
63 ****************************************************************************/
64 contract MAJz is ERC20Token, Ownership {
65     using SafeMath for uint256;
66 
67     string public symbol;
68     string public name;
69     uint256 public decimals;
70     uint256 public totalSupply;
71 
72     mapping(address => uint256) public balances;
73     mapping(address => mapping(address => uint256)) allowed;
74     
75     //Constructor of the Token
76     constructor() public{
77         symbol = "MAZ";
78         name = "MAJz";
79         decimals = 18;
80         totalSupply = 560000000000000000000000000;
81         balances[msg.sender] = totalSupply;
82         owner = msg.sender;
83         emit Transfer(address(0), msg.sender, totalSupply); 
84     }
85 
86 
87     /****************************************************************************
88     *                   Basic Token Functions                                   *
89     ****************************************************************************/
90     //Returns the totalSupply
91     function totalSupply() public view returns (uint256) {
92         return totalSupply;
93     }
94     //Return the balance of an specified account
95     function balanceOf(address _targetAddress) public view returns (uint256) {
96         return balances[_targetAddress];
97     }
98     
99     //Transfer function. Validates targetAdress not to be 0x0
100     function transfer(address _targetAddress, uint256 _value) validDestination(_targetAddress) public returns (bool) {
101         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value); //SafeMath will throw if value > balance
102         balances[_targetAddress] = SafeMath.add(balances[_targetAddress], _value);
103         emit Transfer(msg.sender, _targetAddress, _value); 
104         return true; 
105     }
106 
107     /****************************************************************************
108     *                   ERC20 Token Functions                                   *
109     ****************************************************************************/
110     function allowance(address _originAddress, address _targetAddress) public view returns (uint256){
111         return allowed[_originAddress][_targetAddress];
112     }
113 
114     function approve(address _targetAddress, uint256 _value) public returns (bool) {
115         allowed[msg.sender][_targetAddress] = _value;
116         emit Approval(msg.sender, _targetAddress, _value);
117         return true;
118     }
119 
120     function transferFrom(address _originAddress, address _targetAddress, uint256 _value) public returns (bool) {
121         balances[_originAddress] = SafeMath.sub(balances[_originAddress], _value); //SafeMath will throw if _value> balanceOf[_originAddress]
122         allowed[_originAddress][msg.sender] = SafeMath.sub(allowed[_originAddress][msg.sender], _value); //SafeMath will throw if _value > allowance
123         balances[_targetAddress] = SafeMath.add(balances[_targetAddress], _value);
124         emit Transfer(_originAddress, _targetAddress, _value);
125         return true;
126     }
127 
128     function () public payable {
129         revert();
130     }
131 
132     /****************************************************************************
133     *                   Extended Functionalites                                 *
134     ****************************************************************************/
135 
136     //Burn the specified amount (_value) of tokens
137     function burnTokens(uint256 _value) public onlyOwner returns (bool){
138         balances[owner] = SafeMath.sub(balances[owner], _value); //SafeMath will throw if value > balance
139         totalSupply = SafeMath.sub(totalSupply, _value);
140         emit BurnTokens(_value);
141         return true;
142     }
143 
144     //Emit new tokens
145     function emitTokens(uint256 _value) public onlyOwner returns (bool){
146         balances[owner] = SafeMath.add(balances[owner], _value); //SafeMath will throw if Overflow
147         totalSupply = SafeMath.add(totalSupply, _value);
148         emit EmitTokens(_value);
149         return true;
150     }
151 
152     //Revert a transfer in case of error. onlyOwner
153     function revertTransfer(address _targetAddress, uint256 _value) public onlyOwner returns (bool) {
154         balances[_targetAddress] = SafeMath.sub(balances[_targetAddress], _value);
155         balances[owner] = SafeMath.add(balances[owner], _value);
156         emit RevertTransfer(_targetAddress, _value);
157         return true;
158     }
159     
160     event RevertTransfer(address _targetAddress, uint256 _value);
161     event BurnTokens(uint256 _value);
162     event EmitTokens(uint256 _value);
163 }