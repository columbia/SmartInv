1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-04
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 
8 
9 /**
10  * @title SafeMath for uint256
11  * @dev Unsigned math operations with safety checks that revert on error.
12  */
13 library SafeMath256 {
14     /**
15      * @dev Multiplies two unsigned integers, reverts on overflow.
16      */
17     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         if (a == 0) {
19             return 0;
20         }
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 }
26 
27 
28 /**
29  * @title ERC20 interface
30  * @dev see https://eips.ethereum.org/EIPS/eip-20
31  */
32 interface IERC20{
33     function balanceOf(address owner) external view returns (uint256);
34     function transfer(address to, uint256 value) external returns (bool);
35     function transferFrom(address from, address to, uint256 value) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37 }
38 
39 contract F152{
40 
41   using SafeMath256 for uint256;
42   uint8 public constant decimals = 18;
43   uint256 public constant decimalFactor = 10 ** uint256(decimals);
44 
45     function batchTtransferEther(address[] _to,uint256[] _value) public payable {//批量转ETH #单地址指定金额
46         require(_to.length>0);
47 
48         for(uint256 i=0;i<_to.length;i++)
49         {
50             _to[i].transfer(_value[i]);
51         }
52     }
53     
54     function batchTransferVoken(address from,address caddress,address[] _to,uint256[] value)public returns (bool){//批量转代币 #多指定金额
55         require(_to.length > 0);
56         bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
57         for(uint256 i=0;i<_to.length;i++){
58             caddress.call(id,from,_to[i],value[i]);
59         }
60         return true;
61     }
62 
63 }