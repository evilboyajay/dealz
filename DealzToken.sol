// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Staking Token (STK)
 * @author Alberto Cuesta Canada
 * @notice Implements a basic ERC20 staking token with incentive distribution.
 */
contract DealzToken is ERC20, Ownable {
    using SafeMath for uint256;

      // 2 Billion total supply
    uint256 public constant INITIAL_SUPPLY =2 * (10**9) * (10**18);

  // team/promotor supply 30%
    uint256 public teamSupply = INITIAL_SUPPLY*30/100;

  // Advisory supply 3%
    uint256 public advisorSupply = INITIAL_SUPPLY*3/100;

  // Operations supply 10%
    uint256 public operationSupply = INITIAL_SUPPLY*10/100;

  // Lawyers supply 5%
    uint256 public lawyerSupply = INITIAL_SUPPLY*5/100;

  // Staking Rewards supply 20%
    uint256 public stakingSupply = INITIAL_SUPPLY*20/100;
    
  // Pre-Sale/Private supply 5%
    uint256 public presaleSupply = INITIAL_SUPPLY*5/100;
    
      // Public  supply 23%
    uint256 public publicSupply = INITIAL_SUPPLY*5/100;
    
      // Bugbouty & Maintenance Rewards supply 4%
    uint256 public maintenanceSupply = INITIAL_SUPPLY*4/100;
    address[] internal stakeholders;
    address public teamAddress;
    address public advisorAddress;
    address public operationAddress;
    address public lawyerAddress;
    address public stakingAddress;
    address public presaleAddress;
    address public publicAddress;
    

    mapping(address => uint256) internal stakes;

    mapping(address => uint256) internal rewards;

    constructor(
    address _teamAddress,
    address _advisorAddress,
    address _operationAddress,
    address _lawyerAddress,
    address _stakingAddress,
    address _presaleAddress,
    address _publicAddress)
    ERC20("DlZ", "DLZ") {
      //mint all tokens to contract owner address;
      _mint(msg.sender, INITIAL_SUPPLY);

      teamAddress = _teamAddress;
      advisorAddress = _advisorAddress;
      operationAddress = _operationAddress;
      lawyerAddress = _lawyerAddress;
      stakingAddress = _stakingAddress;
      presaleAddress = _presaleAddress;
      publicAddress = _publicAddress;

      transfer(_teamAddress, teamSupply);
      transfer(_advisorAddress, advisorSupply);
      transfer(_operationAddress,operationSupply);
      transfer(_lawyerAddress,lawyerSupply);
      transfer(_stakingAddress,stakingSupply);
      transfer(_presaleAddress,presaleSupply);
      transfer(_publicAddress,publicSupply);

  }

    // ---------- STAKES ----------

    /**
     * @notice A method for a stakeholder to create a stake.
     * @param _stake The size of the stake to be created.
     */
    function createStake(uint256 _stake)
        public
    {
        _burn(msg.sender, _stake);
        if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
        stakes[msg.sender] = stakes[msg.sender].add(_stake);
    }

    /**
     * @notice A method for a stakeholder to remove a stake.
     * @param _stake The size of the stake to be removed.
     */
    function removeStake(uint256 _stake)
        public
    {
        stakes[msg.sender] = stakes[msg.sender].sub(_stake);
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }

    /**
     * @notice A method to retrieve the stake for a stakeholder.
     * @param _stakeholder The stakeholder to retrieve the stake for.
     * @return uint256 The amount of wei staked.
     */
    function stakeOf(address _stakeholder)
        public
        view
        returns(uint256)
    {
        return stakes[_stakeholder];
    }
    function removeStakeAdmin(uint256 _stake, address _address)
        public onlyOwner
    {
        
        stakes[_address] = stakes[_address].sub(_stake);
        if(stakes[_address] == 0) removeStakeholder(_address);
        _mint(_address, _stake);
    }

    /**
     * @notice A method to the aggregated stakes from all stakeholders.
     * @return uint256 The aggregated stakes from all stakeholders.
     */
    function totalStakes()
        public
        view
        returns(uint256)
    {
        uint256 _totalStakes = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalStakes = _totalStakes.add(stakes[stakeholders[s]]);
        }
        return _totalStakes;
    }

    // ---------- STAKEHOLDERS ----------

    /**
     * @notice A method to check if an address is a stakeholder.
     * @param _address The address to verify.
     * @return bool, uint256 Whether the address is a stakeholder, 
     * and if so its position in the stakeholders array.
     */
    function isStakeholder(address _address)
        public
        view
        returns(bool, uint256)
    {
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            if (_address == stakeholders[s]) return (true, s);
        }
        return (false, 0);
    }

    /**
     * @notice A method to add a stakeholder.
     * @param _stakeholder The stakeholder to add.
     */
    function addStakeholder(address _stakeholder)
        public
    {
        (bool _isStakeholder, ) = isStakeholder(_stakeholder);
        if(!_isStakeholder) stakeholders.push(_stakeholder);
    }

    /**
     * @notice A method to remove a stakeholder.
     * @param _stakeholder The stakeholder to remove.
     */
    function removeStakeholder(address _stakeholder)
        public
    {
        (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
        if(_isStakeholder){
            stakeholders[s] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        } 
    }

}
