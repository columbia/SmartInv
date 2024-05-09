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
41     uint public bb;
42     
43     /**
44     * @param _token An address for ERC20 token which would be swaped be bep2
45     */
46     constructor(ERC20 _token) public {
47         token = _token;
48         owner = msg.sender;
49     }
50     
51     modifier onlyOwner() {
52         require(msg.sender == owner, "Caller is not the owner");
53         _;
54     }
55     
56     event OwnerChanged(address oldOwner, address newOwner);
57     
58     /**
59     * @dev only to be called by the owner of Swap contract
60     * @param _newOwner An address to replace the old owner with.
61     */
62     function changeOwner(address _newOwner) public onlyOwner {
63         owner = _newOwner;
64         emit OwnerChanged(msg.sender, owner);
65     }
66     
67     event Swaped(uint tokenAmount, string BNB_Address);
68     
69     /**
70     * @param tokenAmount Amount of tokens to swap with bep2
71     * @param BNB_Address address of Binance Chain to which to receive the bep2 tokens
72     */
73     function swap(uint tokenAmount, string memory BNB_Address) public returns(bool) {
74         
75         bool success = token.transferFrom(msg.sender, owner, tokenAmount);
76         
77         if(!success) {
78             revert("Transfer of tokens to Swap contract failed.");
79         }
80         
81         emit Swaped(tokenAmount, BNB_Address);
82         
83         return true;
84         
85     }
86     
87 }