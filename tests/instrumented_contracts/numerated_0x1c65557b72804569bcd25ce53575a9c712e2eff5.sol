1 // Play2LivePromo token smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 
4 pragma solidity ^0.4.18;
5 
6 contract Play2LivePromo {
7     //Owner address
8     address public owner;
9     //Public variables of the token
10     string public constant name  = "Level Up Coin Diamond | play2live.io";
11     string public constant symbol = "LUCD";
12     uint8 public constant decimals = 18;
13     uint public totalSupply = 0; 
14     uint256 promoValue = 777 * 1e18;
15     mapping(address => uint) balances;
16     mapping(address => mapping (address => uint)) allowed;
17     // Events Log
18     event Transfer(address _from, address _to, uint256 amount); 
19     event Approval(address indexed _owner, address indexed _spender, uint _value);
20     // Modifiers
21     // Allows execution by the contract owner only
22     modifier onlyOwner {
23         require(msg.sender == owner);
24         _;
25     }  
26 
27    /**
28     *   @dev Contract constructor function sets owner address
29     */
30     function Play2LivePromo() {
31         owner = msg.sender;
32     }
33 
34     /**
35     *   @dev Allows owner to change promo value
36     *   @param _newValue      new   
37     */
38     function setPromo(uint256 _newValue) external onlyOwner {
39         promoValue = _newValue;
40     }
41 
42    /**
43     *   @dev Get balance of investor
44     *   @param _investor     investor's address
45     *   @return              balance of investor
46     */
47     function balanceOf(address _investor) public constant returns(uint256) {
48         return balances[_investor];
49     }
50 
51 
52    /**
53     *   @dev Mint tokens
54     *   @param _investor     beneficiary address the tokens will be issued to
55     */
56     function mintTokens(address _investor) external onlyOwner {
57         balances[_investor] +=  promoValue;
58         totalSupply += promoValue;
59         Transfer(0x0, _investor, promoValue);
60         
61     }
62 
63 
64    /**
65     *   @dev Send coins
66     *   throws on any error rather then return a false flag to minimize
67     *   user errors
68     *   @param _to           target address
69     *   @param _amount       transfer amount
70     *
71     *   @return true if the transfer was successful
72     */
73     function transfer(address _to, uint _amount) public returns (bool) {
74         balances[msg.sender] -= _amount;
75         balances[_to] -= _amount;
76         Transfer(msg.sender, _to, _amount);
77         return true;
78     }
79 
80    /**
81     *   @dev An account/contract attempts to get the coins
82     *   throws on any error rather then return a false flag to minimize user errors
83     *
84     *   @param _from         source address
85     *   @param _to           target address
86     *   @param _amount       transfer amount
87     *
88     *   @return true if the transfer was successful
89     */
90     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
91         balances[_from] -= _amount;
92         allowed[_from][msg.sender] -= _amount;
93         balances[_to] -= _amount;
94         Transfer(_from, _to, _amount);
95         return true;
96      }
97 
98 
99    /**
100     *   @dev Allows another account/contract to spend some tokens on its behalf
101     *   throws on any error rather then return a false flag to minimize user errors
102     *
103     *   also, to minimize the risk of the approve/transferFrom attack vector
104     *   approve has to be called twice in 2 separate transactions - once to
105     *   change the allowance to 0 and secondly to change it to the new allowance
106     *   value
107     *
108     *   @param _spender      approved address
109     *   @param _amount       allowance amount
110     *
111     *   @return true if the approval was successful
112     */
113     function approve(address _spender, uint _amount) public returns (bool) {
114         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
115         allowed[msg.sender][_spender] = _amount;
116         Approval(msg.sender, _spender, _amount);
117         return true;
118     }
119 
120    /**
121     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
122     *
123     *   @param _owner        the address which owns the funds
124     *   @param _spender      the address which will spend the funds
125     *
126     *   @return              the amount of tokens still avaible for the spender
127     */
128     function allowance(address _owner, address _spender) constant returns (uint) {
129         return allowed[_owner][_spender];
130     }
131 }