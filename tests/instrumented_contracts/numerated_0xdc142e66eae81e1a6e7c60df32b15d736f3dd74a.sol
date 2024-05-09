1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4     function transfer(address _to, uint256 _value) public returns(bool);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6 }
7 
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 contract Airdropper is Ownable {
46 
47     address public tokenAddr = 0x0;
48     uint256 public numOfTokens;
49     ERC20 public token;
50 
51     function Airdropper(address _tokenAddr, uint256 _numOfTokens) public {
52         tokenAddr = _tokenAddr;
53         numOfTokens = _numOfTokens;
54         token = ERC20(_tokenAddr);
55     }
56 
57     function multisend(address[] dests) public onlyOwner returns (uint256) {
58         uint256 i = 0;
59         while (i < dests.length) {
60            require(token.transfer(dests[i], numOfTokens));
61            i += 1;
62         }
63         return(i);
64     }
65 
66     function getLendTokenBalance() public constant returns (uint256) {
67         return token.balanceOf(this);
68     }
69 
70     //Function to get the locked tokens back, in case of any issue
71     //Return the tokens to the owner's address
72     function withdrawRemainingTokens() public onlyOwner  {
73         uint contractTokenBalance = token.balanceOf(this);
74         require(contractTokenBalance > 0);        
75         token.transfer(owner, contractTokenBalance);
76     }
77 
78 
79     // Method to get any locked ERC20 tokens
80     function withdrawERC20ToOwner(address _erc20) public onlyOwner {
81         ERC20 erc20Token = ERC20(_erc20);
82         uint contractTokenBalance = erc20Token.balanceOf(this);
83         require(contractTokenBalance > 0);
84         erc20Token.transfer(owner, contractTokenBalance);
85     }
86 
87 }