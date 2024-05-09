1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(
12         address indexed previousOwner,
13         address indexed newOwner
14     );
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     constructor() internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @return the address of the owner.
27      */
28     function owner() public view returns(address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner());
37         _;
38     }
39 
40     /**
41      * @return true if `msg.sender` is the owner of the contract.
42      */
43     function isOwner() public view returns(bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Allows the current owner to relinquish control of the contract.
49      * @notice Renouncing to ownership will leave the contract without an owner.
50      * It will not be possible to call the functions with the `onlyOwner`
51      * modifier anymore.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 contract Ethpen is Ownable {
77     mapping (address => mapping (bytes32 =>uint)) public paidAmount;
78     mapping (address => uint) public balances;
79     uint8 public feeRate;
80 
81     event PayForUrl(address _from, address _creator, string _url, uint amount);
82     event Withdraw(address _from, uint amount);
83     constructor (uint8 _feeRate) public {
84         feeRate = _feeRate;
85     }
86     function payForUrl(address _creator,string _url) public payable {
87         uint fee = (msg.value * feeRate) / 100; 
88         balances[owner()] += fee;
89         balances[_creator] += msg.value - fee;
90         paidAmount[msg.sender][keccak256(_url)] += msg.value;
91         emit PayForUrl(msg.sender,_creator,_url,msg.value);
92     }
93     function setFeeRate (uint8 _feeRate)public onlyOwner{
94         require(_feeRate < feeRate, "Cannot raise fee rate");
95         feeRate = _feeRate;
96     }
97     function withdraw() public{
98         uint balance = balances[msg.sender];
99         require(balance > 0, "Balance must be greater than zero");
100         balances[msg.sender] = 0;
101         msg.sender.transfer(balance);
102         emit Withdraw(msg.sender, balance);
103     }
104 }