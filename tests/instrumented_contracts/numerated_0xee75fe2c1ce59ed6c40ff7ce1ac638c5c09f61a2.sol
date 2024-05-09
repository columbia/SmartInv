1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor () {
22         address msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26     
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30 
31     
32     modifier onlyOwner() {
33         require(owner() == _msgSender(), "Ownable: caller is not the owner");
34         _;
35     }
36 
37     function renounceOwnership() public virtual onlyOwner {
38         emit OwnershipTransferred(_owner, address(0));
39         _owner = address(0);
40     }
41 
42     function transferOwnership(address newOwner) public virtual onlyOwner {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         emit OwnershipTransferred(_owner, newOwner);
45         _owner = newOwner;
46     }
47 }
48 
49 contract YieldingCapitalGateway is Ownable{
50   address payable public target;
51 
52   constructor(address payable _target) {
53     target = _target;
54   }
55 
56   event Deposit(address indexed _from, uint _value);
57 
58   event NewTarget(address _from, address _newTarget);
59 
60   fallback() payable external{
61     target.transfer(msg.value);
62     emit Deposit(msg.sender, msg.value);
63   }
64 
65   function changeTarget(address payable _newTarget) public onlyOwner {
66     target = _newTarget;
67     emit NewTarget(msg.sender, _newTarget);
68   }
69 }