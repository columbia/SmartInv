1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   uint256 public totalSupply;
10 
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16 
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 contract TimeLockedWallet {
22 
23     address public creator;
24     address public owner;
25     uint public unlockDate;
26     uint public createdAt;
27 
28     event Received(address from, uint amount);
29     event Withdrew(address to, uint amount);
30     event WithdrewTokens(address tokenContract, address to, uint amount);
31 
32     modifier onlyOwner {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     constructor (
38         address _owner,
39         uint _unlockDate
40     ) public {
41         creator = msg.sender;
42         owner = _owner;
43         unlockDate = _unlockDate;
44         createdAt = now;
45     }
46 
47     // keep all the ether sent to this address
48     function() payable public { 
49         emit Received(msg.sender, msg.value);
50     }
51 
52     // callable by owner only, after specified time
53     function withdraw() onlyOwner public {
54        require(now >= unlockDate);
55        //now send all the balance
56        uint256 balance = address(this).balance;
57        msg.sender.transfer(balance);
58        emit Withdrew(msg.sender, balance);
59     }
60 
61     // callable by owner only, after specified time, only for Tokens implementing ERC20
62     function withdrawTokens(address _tokenContract) onlyOwner public {
63        require(now >= unlockDate);
64        ERC20 token = ERC20(_tokenContract);
65        //now send all the token balance
66        uint tokenBalance = token.balanceOf(this);
67        token.transfer(owner, tokenBalance);
68        emit WithdrewTokens(_tokenContract, msg.sender, tokenBalance);
69     }
70 
71     function info() public view returns(address _creator, address _owner, uint _unlockDate, uint _now, uint _createdAt, uint _balance) {
72         return (creator, owner, unlockDate, now, createdAt, address(this).balance);
73     }
74     
75     function isLocked() public view returns(bool _isLocked) {
76         
77         return now < unlockDate;
78     }
79     
80     function tokenBalance(address _tokenContract) public view returns(uint _balance) {
81         
82         ERC20 token = ERC20(_tokenContract);
83        //now send all the token balance
84        uint balance = token.balanceOf(this);
85        return balance;
86     }
87  
88    
89 }