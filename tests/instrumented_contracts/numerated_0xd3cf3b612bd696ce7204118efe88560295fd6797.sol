1 /*
2     xgr_fork.sol
3     2.0.0
4     
5     Rajci 'iFA' Andor @ ifa@fusionwallet.io
6 */
7 pragma solidity 0.4.18;
8 
9 contract Owned {
10     /* Variables */
11     address public owner = msg.sender;
12     /* Externals */
13     function replaceOwner(address newOwner) external returns(bool success) {
14         require( isOwner() );
15         owner = newOwner;
16         return true;
17     }
18     /* Internals */
19     function isOwner() internal view returns(bool) {
20         return owner == msg.sender;
21     }
22     /* Modifiers */
23     modifier onlyForOwner {
24         require( isOwner() );
25         _;
26     }
27 }
28 
29 contract Token {
30     /*
31         This is just an abstract contract with the necessary functions
32     */
33     function mint(address owner, uint256 value) external returns (bool success) {}
34 }
35 
36 contract Fork is Owned {
37     /* Variables */
38     address public uploader;
39     address public tokenAddress;
40     /* Constructor */
41     function Fork(address _uploader) public {
42         uploader = _uploader;
43     }
44     /* Externals */
45     function changeTokenAddress(address newTokenAddress) external onlyForOwner {
46         tokenAddress = newTokenAddress;
47     }
48     function upload(address[] addr, uint256[] amount) external onlyForUploader {
49         require( addr.length == amount.length );
50         for ( uint256 a=0 ; a<addr.length ; a++ ) {
51             require( Token(tokenAddress).mint(addr[a], amount[a]) );
52         }
53     }
54     /* Modifiers */
55     modifier onlyForUploader {
56         require( msg.sender == uploader );
57         _;
58     }
59 }