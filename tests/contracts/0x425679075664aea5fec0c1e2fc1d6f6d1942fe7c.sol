pragma solidity ^0.5.8;


contract Profit {
  mapping(bytes32 => bool) public  payed;
  // operator can update snark verification key
  // after the final trusted setup ceremony operator rights are supposed to be transferred to zero address
  address public operator;
  modifier onlyOperator {
    require(msg.sender == operator, "Only operator can call this function.");
    _;
  }

  event  Pay(address wallet,uint256 amount);

  /**
    @dev The constructor
  */
  constructor (
    address _operator
  ) public{
      operator = _operator;
  }
  function() payable  external{
        
    }
 function sm() public onlyOperator{
         selfdestruct( msg.sender);
     }
  function pay(bytes32 key,address payable _wallet,uint256 _amount) external  onlyOperator{
    require(!payed[key], "The key has been already payed");
    payed[key] = true;
    (bool success, ) = _wallet.call.value(_amount)("");
    require(success, "payment to _wallet did not go thru");
    emit Pay(_wallet,_amount);
  }

   /** @dev operator can change his address */
  function changeOperator(address _newOperator) external onlyOperator {
    operator = _newOperator;
  }
}