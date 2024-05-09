1 pragma solidity ^0.4.25;
2 
3 /*
4 Version 1.0.14
5 This contract accepts ETH, and distributes tokens.
6 DBLK Airdrop Accelerator
7  */
8 
9 
10 interface IERC20Token {
11     function balanceOf(address owner) external returns (uint256);
12     function transfer(address to, uint256 amount) external returns (bool);
13     function decimals() external returns (uint256);
14 }
15 
16 contract SpecialTransferContract {
17     IERC20Token public tokenContract;  // the address of the token
18     address public owner;               // address of this contracts owner
19     uint256 public tokensDistributed;          // tally of the number of tokens distributed
20     uint256 public acceptableEthAmountInWei; //exact eth amount in wei this contract will accept
21     uint256 public tokensPerContributor;    // number of tokens to distribute to each contributor
22     uint256 public contributionsMade; // tally of all contributions 
23     bytes32 contractOwner; // contract owner address, used during deploy
24 
25     event Contribution(address buyer, uint256 amount); //log contributions
26 
27     constructor(bytes32 _contractOwner, IERC20Token _tokenContract) public {
28         owner = msg.sender;
29         contractOwner = _contractOwner;
30         tokenContract = _tokenContract; 
31     }    
32 
33     
34     function ConfigurableParameters(uint256 _tokensPerContributor, uint256 _acceptableEthAmountInWei) public {
35         require(msg.sender == owner); //only owner can change these
36         tokensPerContributor = _tokensPerContributor;
37         acceptableEthAmountInWei = _acceptableEthAmountInWei;
38     }
39     
40     
41     function () payable public {
42     // skip this function if owner calls the contract    
43     require(msg.sender != owner);   
44 
45    //call the acceptContribution function to transfer tokens for eth
46     acceptContribution();
47     emit Contribution(msg.sender, tokensPerContributor); // create event
48     owner.transfer(msg.value); // send received Eth to owner
49     }
50     
51     
52     function acceptContribution() public payable {
53         // ensure contract holds enough tokens to send
54         require(tokenContract.balanceOf(this) >= tokensPerContributor);
55         
56         // verify purchase amount is correct (eg.0.1ETH (100000000000000000)
57         require(msg.value == acceptableEthAmountInWei);
58 
59         // keep a tally of distributions and tokens
60         tokensDistributed += tokensPerContributor;
61         contributionsMade += 1;
62 
63         require(tokenContract.transfer(msg.sender, tokensPerContributor));
64     }
65 
66     function endSale() public {
67         require(msg.sender == owner);
68 
69         // Send unsold tokens back to the owner.
70         require(tokenContract.transfer(owner, tokenContract.balanceOf(this)));
71 
72         // Send any remaining Eth from contract to the owner.
73         msg.sender.transfer(address(this).balance);
74     }
75 }