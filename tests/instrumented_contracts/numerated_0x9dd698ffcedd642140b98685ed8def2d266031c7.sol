1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   uint256 public totalSupply;
5 
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   function allowance(address owner, address spender) public view returns (uint256);
9   function transferFrom(address from, address to, uint256 value) public returns (bool);
10   function approve(address spender, uint256 value) public returns (bool);
11 
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 contract TimeLockedWallet {
17 
18     address public creator;
19     address public owner;
20     uint public unlockDate;
21     uint public createdAt;
22 
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     constructor(
29         address _creator,
30         address _owner,
31         uint _unlockDate
32     ) public {
33         creator = _creator;
34         owner = _owner;
35         unlockDate = _unlockDate;
36         createdAt = now;
37     }
38 
39     // keep all the ether sent to this address
40     function() payable public { 
41         emit Received(msg.sender, msg.value);
42     }
43 
44     // callable by owner only, after specified time
45     function withdraw() onlyOwner public {
46        require(now >= unlockDate);
47        address myAddress = this;
48        
49        //now send all the balance
50        msg.sender.transfer(myAddress.balance);
51        emit Withdrew(msg.sender, myAddress.balance );
52     }
53 
54     // callable by owner only, after specified time, only for Tokens implementing ERC20
55     function withdrawTokens(address _tokenContract) onlyOwner public {
56        require(now >= unlockDate);
57        ERC20 token = ERC20(_tokenContract);
58        //now send all the token balance
59        uint tokenBalance = token.balanceOf(this);
60        token.transfer(owner, tokenBalance);
61        emit WithdrewTokens(_tokenContract, msg.sender, tokenBalance);
62     }
63 
64     function info() public view returns(address, address, uint, uint, uint) {
65         return (creator, owner, unlockDate, createdAt, address(this).balance);
66     }
67 
68     event Received(address from, uint amount);
69     event Withdrew(address to, uint amount);
70     event WithdrewTokens(address tokenContract, address to, uint amount);
71 }
72 
73 contract TimeLockedWalletFactory {
74  
75     mapping(address => address[]) wallets;
76 
77     function getWallets(address _user) 
78         public
79         view
80         returns(address[])
81     {
82         return wallets[_user];
83     }
84 
85     function newTimeLockedWallet(address _owner, uint _unlockDate)
86         payable
87         public
88         returns(address wallet)
89     {
90         // Create new wallet.
91         wallet = new TimeLockedWallet(msg.sender, _owner, _unlockDate);
92         
93         // Add wallet to sender's wallets.
94         wallets[msg.sender].push(wallet);
95 
96         // If owner is the same as sender then add wallet to sender's wallets too.
97         if(msg.sender != _owner){
98             wallets[_owner].push(wallet);
99         }
100 
101         // Send ether from this transaction to the created contract.
102         wallet.transfer(msg.value);
103 
104         // Emit event.
105         emit Created(wallet, msg.sender, _owner, now, _unlockDate, msg.value);
106     }
107 
108     // Prevents accidental sending of ether to the factory
109     function () public {
110         revert();
111     }
112 
113     event Created(address wallet, address from, address to, uint createdAt, uint unlockDate, uint amount);
114 }