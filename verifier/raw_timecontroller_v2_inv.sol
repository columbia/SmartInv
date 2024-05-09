pragma solidity ^0.5.0;
import "./SafeMath.sol";
import "./Libraries/IERC20.sol";
//import "./Libraries/Lib.sol";
import "./Libraries/VeriSolContracts.sol";



contract TimelockController is IERC20 {
    
    struct Proposal {
          uint256 sTime; 
          address newOwner; 
          }
     address  internal owner;
     IERC20 votingToken;
     address[] internal votedProposals;
     Proposal  internal proposal;
     uint256  internal lockedFunds;
    
    function votedProposal(address voter) internal returns (address[] memory) {        
        votedProposals.push(voter);
        return votedProposals;    
        }

     
    function getAllProposals() internal returns (address[] memory) {        
        return votedProposals;    
        }

    function findHighest(address[] memory votedProposals) internal returns (address){
        address highestProposal;
        uint256 highestAmount;
         highestAmount = 0;
        for (uint i=0; i<votedProposals.length; i++) {
            uint256 accountBalance = votingToken.balanceOf(votedProposals[i]);
            if (accountBalance > highestAmount) {
                highestAmount = accountBalance; 
                highestProposal = votedProposals[i];
            }    
        }
        return highestProposal;
        }

    function startExecute() external {
              require(proposal.sTime == 0,"on-going proposal");
              proposal = Proposal(block.timestamp, msg.sender);
        }

    function execute(uint amount) external {
              require(proposal.sTime + 24 > block.timestamp, "execution has ended");
              votingToken.transferFrom(msg.sender, address(this), amount); 
              votedProposal(msg.sender);    
        }
    function endExecute() external {
              require(proposal.sTime != 0, "no proposal");
              require(proposal.sTime + 24 < block.timestamp, "execution has not ended");
              require(votingToken.balanceOf(address(this))*2 > votingToken.totalSupply(), "execution failed");
              //SmartInv inferred: 
              lockedFunds = votingToken.balanceOf(address(this));
              assert(lockedFunds == VeriSol.Old(lockedFunds));
              owner = findHighest(getAllProposals());
              delete proposal;
        }
    function rewardFunds() public returns (uint256) {
        return lockedFunds;
    }

}