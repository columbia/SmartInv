1 pragma solidity ^0.4.24;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an emitter and administrator addresses, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address emitter;
12     address administrator;
13 
14     /**
15      * @dev Sets the original `emitter` of the contract
16      */
17     function setEmitter(address _emitter) internal {
18         require(_emitter != address(0));
19         require(emitter == address(0));
20         emitter = _emitter;
21     }
22 
23     /**
24      * @dev Sets the original `administrator` of the contract
25      */
26     function setAdministrator(address _administrator) internal {
27         require(_administrator != address(0));
28         require(administrator == address(0));
29         administrator = _administrator;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the emitter.
34      */
35     modifier onlyEmitter() {
36         require(msg.sender == emitter);
37         _;
38     }
39 
40     /**
41      * @dev Throws if called by any account other than the administrator.
42      */
43     modifier onlyAdministrator() {
44         require(msg.sender == administrator);
45         _;
46     }
47 
48     /**
49    * @dev Allows the current super emitter to transfer control of the contract to a emitter.
50    * @param _emitter The address to transfer emitter ownership to.
51    * @param _administrator The address to transfer administrator ownership to.
52    */
53     function transferOwnership(address _emitter, address _administrator) public onlyAdministrator {
54         require(_emitter != _administrator);
55         require(_emitter != emitter);
56         require(_emitter != address(0));
57         require(_administrator != address(0));
58         emitter = _emitter;
59         administrator = _administrator;
60     }
61 }
62 
63 // File: contracts/GlitchGoonsProxy.sol
64 
65 contract GlitchGoonsProxy is Ownable {
66 
67     constructor (address _emitter, address _administrator) public {
68         setEmitter(_emitter);
69         setAdministrator(_administrator);
70     }
71 
72     function deposit() external payable {
73         emitter.transfer(msg.value);
74     }
75 
76     function transfer(address _to) external payable {
77         _to.transfer(msg.value);
78     }
79 }