1 pragma solidity ^0.5.2;
2 contract ERC20 {
3     function balanceOf(address who) public view returns(uint);
4     function transfer(address to, uint value) public returns(bool);
5 }
6 contract Checked {
7     function isContract(address addr) internal view returns(bool) {
8         uint256 size;
9         assembly { size := extcodesize(addr) }
10         return size > 0;
11     }
12 }
13 contract Address is Checked {
14     Info public ContractDetails;
15     struct Info {
16         address Contract;
17         address Owner;
18         address Creator;
19         uint Block;
20         uint Timestamp;
21         bytes32 Hash;
22     }
23     constructor(address _owner) public {
24         ContractDetails.Contract = address(this);
25         ContractDetails.Owner = _owner;
26         ContractDetails.Creator = msg.sender;
27         ContractDetails.Block = block.number;
28         ContractDetails.Timestamp = now;
29         ContractDetails.Hash = keccak256(abi.encodePacked(address(this), _owner, msg.sender, block.number, now));
30     }
31     modifier onlyOwner() {
32         require(msg.sender == ContractDetails.Owner);
33         _;
34     }
35     function changeOwner(address newOwner) public onlyOwner {
36         require(newOwner != address(0) && address(this) != newOwner);
37         ContractDetails.Owner = newOwner;
38     }
39     function () external payable {}
40     function receive() public payable {
41         if (msg.value < 1) revert();
42     }
43     function transfer(address token, address payable to, uint amount) public onlyOwner {
44         require(to != token && to != address(0) && address(this) != to);
45         require(amount > 0);
46         if (address(0) == token) {
47             require(amount <= address(this).balance);
48             to.transfer(amount);
49         } else {
50             require(isContract(token) && ERC20(token).balanceOf(address(this)) >= amount);
51             if (!ERC20(token).transfer(to, amount)) revert();
52         }
53     }
54     function call(address contractAddr, uint amount, uint gaslimit, bytes memory data) public onlyOwner {
55         require(isContract(contractAddr) && amount <= address(this).balance);
56         if (gaslimit < 35000) gaslimit = 35000;
57         bool success;
58         if (amount > 0) {
59             (success,) = address(uint160(contractAddr)).call.gas(gaslimit).value(amount)(data);
60         } else {
61             (success,) = contractAddr.call.gas(gaslimit).value(amount)(data);
62         }
63         if (!success) revert();
64     }
65 }