//
// AIRA Builder for AiraMarket contract
//
// Ethereum address:
//  - Mainnet:
//  - Testnet: 
//

pragma solidity ^0.4.4;
import 'creator/CreatorAiraMarket.sol';
import './Builder.sol';

/**
 * @title BuilderAiraMarket contract
 */
contract BuilderAiraMarket is Builder {
    /**
     * @dev Run script creation contract
     * @param _client is a contract destination address (zero for sender)
     * @return address new contract
     */
    function create(string _name, address _taxman, uint256 _comission, address _client) payable returns (address) {
        if (buildingCostWei > 0 && beneficiary != 0) {
            // Too low value
            if (msg.value < buildingCostWei) throw;
            // Beneficiary send
            if (!beneficiary.send(buildingCostWei)) throw;
            // Refund
            if (msg.value > buildingCostWei) {
                if (!msg.sender.send(msg.value - buildingCostWei)) throw;
            }
        } else {
            // Refund all
            if (msg.value > 0) {
                if (!msg.sender.send(msg.value)) throw;
            }
        }

        if (_client == 0)
            _client = msg.sender;
 
        var inst = CreatorAiraMarket.create(_name, _taxman, _comission);
        getContractsOf[_client].push(inst);
        Builded(_client, inst);
        inst.setOwner(_client);
        inst.setHammer(_client);
        return inst;
    }
}
