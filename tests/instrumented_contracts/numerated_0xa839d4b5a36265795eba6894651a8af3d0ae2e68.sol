1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address spender, uint256 value) public returns (bool);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract TokenRecipient {
55     event ReceivedEther(address indexed sender, uint amount);
56     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
57 
58     /**
59      * @dev Receive tokens and generate a log event
60      * @param from Address from which to transfer tokens
61      * @param value Amount of tokens to transfer
62      * @param token Address of token
63      * @param extraData Additional data to log
64      */
65     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
66         ERC20 t = ERC20(token);
67         require(t.transferFrom(from, this, value));
68         ReceivedTokens(from, value, token, extraData);
69     }
70 
71     /**
72      * @dev Receive Ether and generate a log event
73      */
74     function () payable public {
75         ReceivedEther(msg.sender, msg.value);
76     }
77 }
78 
79 contract DelegateProxy is TokenRecipient, Ownable {
80 
81     /**
82      * Execute a DELEGATECALL from the proxy contract
83      *
84      * @dev Owner only
85      * @param dest Address to which the call will be sent
86      * @param calldata Calldata to send
87      * @return Result of the delegatecall (success or failure)
88      */
89     function delegateProxy(address dest, bytes calldata)
90         public
91         onlyOwner
92         returns (bool result)
93     {
94         return dest.delegatecall(calldata);
95     }
96 
97     /**
98      * Execute a DELEGATECALL and assert success
99      *
100      * @dev Same functionality as `delegateProxy`, just asserts the return value
101      * @param dest Address to which the call will be sent
102      * @param calldata Calldata to send
103      */
104     function delegateProxyAssert(address dest, bytes calldata)
105         public
106     {
107         require(delegateProxy(dest, calldata));
108     }
109 
110 }
111 
112 contract WyvernDAOProxy is DelegateProxy {
113 
114     function WyvernDAOProxy ()
115         public
116     {
117         owner = msg.sender;
118     }
119 
120 }