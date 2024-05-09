1 pragma solidity ^0.4.23;
2 
3 //A modern ERC-20 token
4 //The airdropper works on any ERC-20 token that implements approve(spender, tokens) 
5 //and transferFrom(from, to, tokens)
6 interface IStandardToken {
7     function totalSupply() external constant returns (uint);
8     function balanceOf(address tokenOwner) external constant returns (uint balance);
9     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
10     function transfer(address to, uint tokens) external returns (bool success);
11     function approve(address spender, uint tokens) external returns (bool success);
12     function transferFrom(address from, address to, uint tokens) external returns (bool success);
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15     function decimals() external returns (uint256);
16 }
17 
18 /*
19  * A  simple airdrop contract for an ERC-20 tokenContract
20  * Usage: 
21  * 1) Pass the address of your token and the # tokens to dispense per user to the constructor.
22  * 2) approve() the address of the newly created YeekAirdropper to 
23  *    spend tokens on your behalf, amount to equal the total number of tokens
24  *    you are airdropping
25  * 3) Have your airdrop recipients call withdrawAirdropTokens() to get their free tokens
26  * 4) Airdrop ends when the approved amount of tokens have been dispensed OR 
27  *  your balance drops too low OR you call endAirdrop()
28  */
29  
30 contract YeekAirdropper {
31     IStandardToken public tokenContract;  // the token being sold
32     address public owner;
33     uint256 public numberOfTokensPerUser;
34     uint256 public tokensDispensed;
35     mapping(address => bool) public airdroppedUsers;
36     address[] public airdropRecipients;
37     event Dispensed(address indexed buyer, uint256 amount);
38     
39     //Constructs an Airdropper for a given token contract
40     constructor(IStandardToken _tokenContract, uint256 _numTokensPerUser) public {
41         owner = msg.sender;
42         tokenContract = _tokenContract;
43         numberOfTokensPerUser = _numTokensPerUser * 10 ** tokenContract.decimals();
44     }
45 
46     //Gets # of people that have already withdrawn their airdrop tokens
47     //In a web3.js client, airdropRecipients.length is not available 
48     //so we need to get the count this way. Any iteration over the 
49     //airdropRecipients array will be done in JS so as not to waste gas
50     function airdropRecipientCount() public view returns(uint) {
51         return airdropRecipients.length;
52     }
53 
54     //Transfers numberOfTokensPerUser from owner to msg.sender
55     //if sufficient remaining tokens exist
56     function withdrawAirdropTokens() public  {
57         require(tokenContract.allowance(owner, this) >= numberOfTokensPerUser);
58         require(tokenContract.balanceOf(owner) >= numberOfTokensPerUser);
59         require(!airdroppedUsers[msg.sender]);  //Each address may only receive the airdrop one time
60         
61         tokensDispensed += numberOfTokensPerUser;
62 
63         airdroppedUsers[msg.sender]  = true;
64         airdropRecipients.length++;
65         airdropRecipients[airdropRecipients.length - 1]= msg.sender;
66         
67         emit Dispensed(msg.sender, numberOfTokensPerUser);
68         tokenContract.transferFrom(owner, msg.sender, numberOfTokensPerUser);
69     }
70 
71     //How many tokens are remaining to be airdropped
72     function tokensRemaining() public view returns (uint256) {
73         return tokenContract.allowance(owner, this);
74     }
75 
76     //Causes this contract to suicide and send any accidentally 
77     //acquired ether to its owner.
78     function endAirdrop() public {
79         require(msg.sender == owner);
80         selfdestruct(msg.sender); //If any ethereum has been accidentally sent to the contract, withdraw it 
81     }
82 }