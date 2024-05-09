1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
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
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 contract SurfersBeach is Ownable {
44     
45     string public name;
46     uint256 public cap;
47     uint256 public contributionMinimum;
48     uint256 public contributionMaximum;
49 
50     uint256 total;
51     
52     mapping (address => bool) public registered;
53     mapping (address => uint256) public balances;
54 
55     event Approval(address indexed account, bool valid);
56     event Contribution(address indexed contributor, uint256 amount);
57     event Transfer(address indexed recipient, uint256 amount, address owner);
58     
59     function SurfersBeach(string _name, uint256 _cap, uint256 _contributionMinimum, uint256 _contributionMaximum) public {
60         require(_contributionMinimum <= _contributionMaximum);
61         require(_contributionMaximum > 0);
62         require(_contributionMaximum <= _cap);
63         name = _name;
64         cap = _cap;
65         contributionMinimum = _contributionMinimum;
66         contributionMaximum = _contributionMaximum;
67     }
68 
69     function () external payable {
70         contribute();
71     }
72         
73     function contribute() public payable {
74         address sender = msg.sender;
75         require(registered[sender]);
76         uint256 value = msg.value;
77         uint256 balance = balances[sender] + value;
78         require(balance >= contributionMinimum);
79         require(balance <= contributionMaximum);
80         require(total + value <= cap);
81         balances[sender] = balance;
82         total += value;
83         Contribution(sender, value);
84     }
85 
86     function register(address account, bool valid) public onlyOwner {
87         require(account != 0);
88         registered[account] = valid;
89         Approval(account, valid);
90     }
91 
92     function transfer(address recipient, uint256 amount) public onlyOwner {
93         require(recipient != 0);
94         require(amount <= this.balance);
95         Transfer(recipient, amount, owner);
96         recipient.transfer(amount);
97     }
98 
99 }