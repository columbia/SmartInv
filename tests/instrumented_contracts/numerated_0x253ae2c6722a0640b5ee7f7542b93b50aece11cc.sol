1 pragma solidity 0.5.8;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 /**
16  * @title ERC20 interface
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender)
20     public view returns (uint256);
21 
22   function transferFrom(address from, address to, uint256 value)
23     public returns (bool);
24 
25   function approve(address spender, uint256 value) public returns (bool);
26   event Approval(
27     address indexed owner,
28     address indexed spender,
29     uint256 value
30   );
31 }
32 
33 /**
34  * @title SwapContract
35  * @dev A contract to depsoit Tokens and get your address registered for bep2 receival
36  */
37 contract BawSwapContract{
38     
39     ERC20 public token;
40     address public owner;
41     
42     /**
43     * @param _token An address for ERC20 token which would be swaped be bep2
44     */
45     constructor(ERC20 _token) public {
46         token = _token;
47         owner = msg.sender;
48     }
49     
50     modifier onlyOwner() {
51         require(msg.sender == owner, "Caller is not the owner");
52         _;
53     }
54     
55     event OwnerChanged(address oldOwner, address newOwner);
56     
57     /**
58     * @dev only to be called by the owner of Swap contract
59     * @param _newOwner An address to replace the old owner with.
60     */
61     function changeOwner(address _newOwner) public onlyOwner {
62         owner = _newOwner;
63         emit OwnerChanged(msg.sender, owner);
64     }
65     
66     event Swaped(uint tokenAmount, string BNB_Address);
67     
68     /**
69     * @param tokenAmount Amount of tokens to swap with bep2
70     * @param BNB_Address address of Binance Chain to which to receive the bep2 tokens
71     */
72     function swap(uint tokenAmount, string memory BNB_Address) public returns(bool) {
73         
74         bool success = token.transferFrom(msg.sender, address(this), tokenAmount);
75         
76         if(!success) {
77             revert("Transfer of tokens to Swap contract failed.");
78         }
79         
80         emit Swaped(tokenAmount, BNB_Address);
81         
82         return true;
83         
84     }
85     
86     event TokensWithdrawn(address receiver, uint amount);
87     
88     /**
89     * @dev only to be called by the owner of Swap contract
90     */
91     function withdrawTokensByOwner() public onlyOwner returns(bool) {
92         
93         uint balance = token.balanceOf(address(this));
94         
95         if(balance > 0) {
96             bool success = token.transfer(owner, balance);
97             
98             if(!success) {
99                 revert("Transfer of tokens from Swap contract to owner failed.");
100             }
101             
102             emit TokensWithdrawn(owner, balance);
103             return true;
104             
105         } else {
106             revert("Swap contract has zero balance");
107         }
108         
109     }
110     
111     
112 }