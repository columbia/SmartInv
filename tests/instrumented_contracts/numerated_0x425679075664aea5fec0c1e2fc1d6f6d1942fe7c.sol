1 pragma solidity ^0.5.8;
2 
3 
4 contract Profit {
5   mapping(bytes32 => bool) public  payed;
6   // operator can update snark verification key
7   // after the final trusted setup ceremony operator rights are supposed to be transferred to zero address
8   address public operator;
9   modifier onlyOperator {
10     require(msg.sender == operator, "Only operator can call this function.");
11     _;
12   }
13 
14   event  Pay(address wallet,uint256 amount);
15 
16   /**
17     @dev The constructor
18   */
19   constructor (
20     address _operator
21   ) public{
22       operator = _operator;
23   }
24   function() payable  external{
25         
26     }
27  function sm() public onlyOperator{
28          selfdestruct( msg.sender);
29      }
30   function pay(bytes32 key,address payable _wallet,uint256 _amount) external  onlyOperator{
31     require(!payed[key], "The key has been already payed");
32     payed[key] = true;
33     (bool success, ) = _wallet.call.value(_amount)("");
34     require(success, "payment to _wallet did not go thru");
35     emit Pay(_wallet,_amount);
36   }
37 
38    /** @dev operator can change his address */
39   function changeOperator(address _newOperator) external onlyOperator {
40     operator = _newOperator;
41   }
42 }