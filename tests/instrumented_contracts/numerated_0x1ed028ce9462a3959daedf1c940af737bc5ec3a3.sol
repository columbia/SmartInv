1 pragma solidity 0.6.7;
2 
3 interface IChiToken {
4     function freeFromUpTo(address from, uint256 value)
5         external
6         returns (uint256 freed);
7 }
8 
9 interface IProxyFactory {
10     function createProxyWithNonce(
11         address _mastercopy,
12         bytes calldata initializer,
13         uint256 saltNonce
14     ) external returns (address proxy);
15 }
16 
17 interface IGnosisSafe {
18     function execTransaction(
19         address to,
20         uint256 value, 
21         bytes calldata data,
22         uint8 operation,
23         uint256 safeTxGas,
24         uint256 baseGas,
25         uint256 gasPrice,
26         address gasToken,
27         address refundReceiver,
28         bytes calldata signatures
29     ) external returns (bool success);
30 }
31 
32 contract Ownable {
33     address public _owner;
34 
35     constructor () internal {
36         _owner = msg.sender;
37     }
38 
39     modifier onlyOwner() {
40         require(_owner == msg.sender, "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function transferOwnership(address newOwner) public onlyOwner {
45         require(newOwner != address(0), "Ownable: new owner is the zero address");
46         _owner = newOwner;
47     }
48 }
49 
50 contract LinenChiWrapper is Ownable {
51     IChiToken public constant _chiToken = IChiToken(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
52     IProxyFactory public constant _factory = IProxyFactory(0x76E2cFc1F5Fa8F6a5b3fC4c8F4788F0116861F9B);
53 
54     modifier discountCHI {
55         uint256 gasStart = gasleft();
56         _;
57         uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
58         _chiToken.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
59     }
60 
61     function createProxyWithNonce(
62         address _mastercopy,
63         bytes calldata initializer,
64         uint256 saltNonce
65     ) external onlyOwner discountCHI returns (address proxy) {
66         return _factory.createProxyWithNonce(_mastercopy, initializer, saltNonce);
67     }
68 
69     function execTransaction(
70         address safeAddress,
71         bytes calldata data
72     ) external onlyOwner discountCHI returns (bool success) {
73         bytes memory _data = data;
74         assembly {
75             success := call(gas(), safeAddress, 0, add(_data, 0x20), mload(_data), 0, 0)
76         }
77         require(success, "LinenChiWrapper: call failed");
78     }
79 }