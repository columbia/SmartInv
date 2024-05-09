1 // Tarka Pre-Sale token smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 
4 pragma solidity ^0.4.15;
5 
6 
7 /**
8  *   @title SafeMath
9  *   @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13         uint256 c = a * b;
14         assert(a == 0 || c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal constant returns(uint256) {
19         assert(b > 0);
20         uint256 c = a / b;
21         assert(a == b * c + a % b);
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal constant returns(uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract PreSalePTARK {
38     using SafeMath for uint256;
39     //Owner address
40     address public owner;
41     //Public variables of the token
42     string public name  = "Tarka Pre-Sale Token";
43     string public symbol = "PTARK";
44     uint8 public decimals = 18;
45     uint256 public totalSupply = 0;
46     mapping (address => uint256) public balances;
47     // Events Log
48     event Transfer(address _from, address _to, uint256 amount); 
49     event Burned(address _from, uint256 amount);
50     // Modifiers
51     // Allows execution by the contract owner only
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }  
56 
57    /**
58     *   @dev Contract constructor function sets owner address
59     */
60     function PreSalePTARK() {
61         owner = msg.sender;
62     }
63 
64    /**
65     *   @dev Allows owner to transfer ownership of contract
66     *   @param _newOwner      newOwner address
67     */
68     function transferOwnership(address _newOwner) external onlyOwner {
69         require(_newOwner != address(0));
70         owner = _newOwner;
71     }
72 
73    /**
74     *   @dev Get balance of investor
75     *   @param _investor     investor's address
76     *   @return              balance of investor
77     */
78     function balanceOf(address _investor) public constant returns(uint256) {
79         return balances[_investor];
80     }
81 
82    /**
83     *   @dev Mint tokens
84     *   @param _investor     beneficiary address the tokens will be issued to
85     *   @param _mintedAmount number of tokens to issue
86     */
87     function mintTokens(address _investor, uint256 _mintedAmount) external onlyOwner {
88         require(_mintedAmount > 0);
89         balances[_investor] = balances[_investor].add(_mintedAmount);
90         totalSupply = totalSupply.add(_mintedAmount);
91         Transfer(this, _investor, _mintedAmount);
92         
93     }
94 
95    /**
96     *   @dev Burn Tokens
97     *   @param _investor     token holder address which the tokens will be burnt
98     */
99     function burnTokens(address _investor) external onlyOwner {   
100         require(balances[_investor] > 0);
101         uint256 tokens = balances[_investor];
102         balances[_investor] = 0;
103         totalSupply = totalSupply.sub(tokens);
104         Burned(_investor, tokens);
105     }
106 }