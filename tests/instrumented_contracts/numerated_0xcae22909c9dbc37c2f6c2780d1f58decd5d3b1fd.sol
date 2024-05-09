1 pragma solidity ^0.4.25;
2 
3 
4 
5 /**
6  * @title SafeMath for uint256
7  * @dev Unsigned math operations with safety checks that revert on error.
8  */
9 library SafeMath256 {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 }
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://eips.ethereum.org/EIPS/eip-20
27  */
28 interface IERC20{
29     function balanceOf(address owner) external view returns (uint256);
30     function transfer(address to, uint256 value) external returns (bool);
31     function transferFrom(address from, address to, uint256 value) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33 }
34 
35 contract A004{
36 
37   using SafeMath256 for uint256;
38   uint8 public constant decimals = 18;
39   uint256 public constant decimalFactor = 10 ** uint256(decimals);
40 
41 function batchTtransferEther(address[] _to,uint256[] _value) public payable {
42     require(_to.length>0);
43     //uint256 distr = msg.value/myAddresses.length;
44     for(uint256 i=0;i<_to.length;i++)
45     {
46         _to[i].transfer(_value[i]);
47     }
48 }
49 
50 /*function batchTtransferEtherToNum(address[] _to,uint256[] _value) public payable {
51     require(_to.length>0);
52     //uint256 distr = msg.value/myAddresses.length;
53     for(uint256 i=0;i<_to.length;i++)
54     {
55         _to[i].transfer(_value[i] * decimalFactor);
56     }
57 }*/
58   
59   /*
60  function batchTtransferEtherToNum1(uint256 _value) public returns(uint256 __value){
61    
62    return _value * decimalFactor;
63 }
64   */
65   
66     
67 }