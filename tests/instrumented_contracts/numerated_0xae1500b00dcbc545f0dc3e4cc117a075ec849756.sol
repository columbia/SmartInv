1 pragma solidity ^0.4.23;
2 
3 // File: contracts/ERC20.sol
4 
5 /**
6  * @title ERC20
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   uint256 public totalSupply;
11 
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   function allowance(address owner, address spender) public view returns (uint256);
15   function transferFrom(address from, address to, uint256 value) public returns (bool);
16   function approve(address spender, uint256 value) public returns (bool);
17 
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 // File: contracts/TimeLockedWallet.sol
23 
24 contract TimeLockedWallet {
25 
26     address public creator;
27     address public owner;
28     uint256 public unlockDate;
29     uint256 public createdAt;
30 
31     modifier onlyOwner {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     constructor(
37         address _creator,
38         address _owner,
39         uint256 _unlockDate
40     ) public {
41         creator = _creator;
42         owner = _owner;
43         unlockDate = _unlockDate;
44         createdAt = now;
45     }
46 
47     // Don't accept ETH.
48     function () public payable {
49         revert();
50     }
51 
52     // callable by owner only, after specified time, only for Tokens implementing ERC20
53     function withdrawTokens(address _tokenContract) public {
54        require(now >= unlockDate);
55        ERC20 token = ERC20(_tokenContract);
56        //now send all the token balance
57        uint256 tokenBalance = token.balanceOf(this);
58        token.transfer(owner, tokenBalance);
59        emit WithdrewTokens(_tokenContract, msg.sender, tokenBalance);
60     }
61 
62     function info() public view returns(address, address, uint256, uint256, uint256) {
63         return (creator, owner, unlockDate, createdAt, address(this).balance);
64     }
65 
66     event Received(address from, uint256 amount);
67     event WithdrewTokens(address tokenContract, address to, uint256 amount);
68 }
69 
70 // File: contracts/TimeLockedWalletFactory.sol
71 
72 contract TimeLockedWalletFactory {
73  
74     mapping(address => address[]) wallets;
75 
76     function getWallets(address _user) 
77         public
78         view
79         returns(address[])
80     {
81         return wallets[_user];
82     }
83 
84     function newTimeLockedWallet(address _owner, uint256 _unlockDate)
85         payable
86         public
87         returns(address wallet)
88     {
89         // Create new wallet.
90         wallet = new TimeLockedWallet(msg.sender, _owner, _unlockDate);
91         
92         // Add wallet to sender's wallets.
93         wallets[msg.sender].push(wallet);
94 
95         // If owner is the same as sender then add wallet to sender's wallets too.
96         if(msg.sender != _owner){
97             wallets[_owner].push(wallet);
98         }
99 
100         // Emit event.
101         emit Created(wallet, msg.sender, _owner, now, _unlockDate, msg.value);
102     }
103 
104     // Prevents accidental sending of ether to the factory
105     function () public {
106         revert();
107     }
108 
109     event Created(address wallet, address from, address to, uint256 createdAt, uint256 unlockDate, uint256 amount);
110 }