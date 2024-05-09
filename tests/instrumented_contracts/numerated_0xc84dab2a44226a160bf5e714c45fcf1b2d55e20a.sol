1 /*
2  * http://solidity.readthedocs.io/en/latest
3  * https://ethereumbuilders.gitbooks.io/guide/content/en/solidity_tutorials.html
4  * Token standard: https://github.com/ethereum/EIPs/issues/20
5  */
6 // import "contracts/StringLib.sol";
7 
8 pragma solidity ^0.4.24;
9 
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) public view returns (uint256);
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeERC20 {
25   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
26     assert(token.transfer(to, value));
27   }
28   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
29     assert(token.transferFrom(from, to, value));
30   }
31   function safeApprove(ERC20 token, address spender, uint256 value) internal {
32     assert(token.approve(spender, value));
33   }
34 }
35 
36 contract owned {
37     address owner;
38 
39     modifier onlyOwner { if (msg.sender == owner) _ ; }
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44 
45     function kill() public {
46         if (msg.sender == owner) {
47             selfdestruct(owner);
48         }
49     }
50 }
51 /*
52  * This contract holds all sold tickets for an event. Tickets are
53  * created on the fly, identified by an id. Owners are identified by
54  * an address.
55  *
56  * The system currently does not support
57  * - privileges
58  * - returning tickets
59  * - execution of tickets
60  */
61 
62 contract GETEventContract is owned {
63     using SafeERC20 for ERC20Basic;
64     event TicketTransfered(address indexed from, address indexed to, uint256 ticketid);
65 
66     // all sold / owned tickets in the system
67     mapping (uint256 => address) public ticketOwner;
68 
69     event GETUnstaked(uint256 amount);
70 
71     function transferTicket(address _receiver, uint256 _ticketid) onlyOwner public {
72         /*
73          * Transfer a specific ticket to a new owner, creating it
74          * on the fly if necessary
75          */
76         ticketOwner[_ticketid] = _receiver;
77     }
78 
79     function unstakeGET(ERC20Basic _token) public onlyOwner {
80         uint256 currentGETBalance = _token.balanceOf(address(this));
81         _token.safeTransfer(owner, currentGETBalance);
82         emit GETUnstaked(currentGETBalance);
83     } 
84 }