1 pragma solidity ^0.4.16;
2 
3 contract Ownable {
4     address public owner;
5 
6     /**
7       * @dev Throws if called by any account other than the owner.
8       */
9     modifier onlyOwner() {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     /**
15       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16       * account.
17       */
18     function Ownable() public {
19         owner = msg.sender;
20     }
21 
22     /**
23     * @dev Allows the current owner to transfer control of the contract to a newOwner.
24     * @param newOwner The address to transfer ownership to.
25     */
26     function transferOwnership(address newOwner) public onlyOwner {
27         if (newOwner != address(0)) {
28             owner = newOwner;
29         }
30     }
31 }
32 
33 
34 contract Pausable is Ownable {
35     bool public paused = false;
36 
37     event Pause();
38     event Unpause();
39 
40     /**
41     * @dev Modifier to make a function callable only when the contract is not paused.
42     */
43     modifier whenNotPaused() {
44         require(!paused);
45         _;
46     }
47 
48     /**
49     * @dev Modifier to make a function callable only when the contract is paused.
50     */
51     modifier whenPaused() {
52         require(paused);
53         _;
54     }
55 
56     /**
57     * @dev called by the owner to pause, triggers stopped state
58     */
59     function pause() onlyOwner whenNotPaused public {
60         paused = true;
61         Pause();
62     }
63 
64     /**
65     * @dev called by the owner to unpause, returns to normal state
66     */
67     function unpause() onlyOwner whenPaused public {
68         paused = false;
69         Unpause();
70     }
71 }
72 
73 
74 contract Register is Pausable {
75     mapping(address => string) public registry;
76 
77     // map 中添加新用户相关信息, eth 地址为合约调用者,仅未暂停状态下可以调用
78     function addUser(string info) public whenNotPaused {
79         registry[msg.sender] = info;
80     }
81    
82     //返回 map 中eth 地址对应的信息
83     function getInfo(address ethAddress) public constant returns (string) {
84         return registry[ethAddress];
85     }
86 }