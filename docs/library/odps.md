# enkinex-odps

## Index

- [DataProduct](#dataproduct)
- common
  - [AuthoritativeCustomizable](#authoritativecustomizable)
  - [AuthoritativeDefinition](#authoritativedefinition)
  - [CustomProperty](#customproperty)
  - [Description](#description)
  - [TagsDiscoverable](#tagsdiscoverable)
- management
  - [ManagementPort](#managementport)
- product
  - [Sbom](#sbom)
  - input
    - [InputContract](#inputcontract)
    - [InputPort](#inputport)
  - output
    - [OutputPort](#outputport)
- support
  - [Support](#support)
- team
  - [Team](#team)
  - [TeamMember](#teammember)

## Schemas

### DataProduct

An open data product standard descriptor to enable defining data products. This schema is the root of an ODPS document and the entry point of the library.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**apiVersion** `required` `readOnly`|"v1.0.0"|Version of the standard used to build the data product.|"v1.0.0"|
|**authoritativeDefinitions**|[[AuthoritativeDefinition](#authoritativedefinition)]|List of links to sources that provide more details on the data product.<br />Examples: link to a business glossary, a transformation implementation, a tutorial, or a data catalog.||
|**customProperties**|[[CustomProperty](#customproperty)]|A list of key/value pairs for custom properties.||
|**description**|[Description](#description)|Object containing the descriptions.||
|**domain**|str|Business domain.<br />Examples: "seller", "customer", "retail-analytics".||
|**id** `required`|str|A unique identifier used to reduce the risk of dataset name collisions, such as a UUID.||
|**inputPorts**|[[InputPort](#inputport)]|List of objects describing an input port.<br />You need at least one as a data product needs to get data somewhere.||
|**kind** `required` `readOnly`|"DataProduct"|The kind of file this is.|"DataProduct"|
|**managementPorts**|[[ManagementPort](#managementport)]|Management ports define access points for managing the data product.||
|**name**|str|Name of the data product.||
|**outputPorts**|[[OutputPort](#outputport)]|List of objects describing an output port.<br />You need at least one, as a data product without output is useless.||
|**productCreatedTs**|str|Timestamp in UTC of when the data product was created, using ISO 8601.||
|**status** `required`|"proposed" \| "draft" \| "active" \| "deprecated" \| "retired"|Current status of the data product.<br />One of "proposed", "draft", "active", "deprecated", "retired".||
|**support**|[[Support](#support)]|Support and communication channels.||
|**tags**|[str]|A list of tags that may be assigned to the elements (object or property).<br />The tags keyword may appear at any level.<br />Tags may be used to better categorize an element.<br />Examples: "finance", "sensitive", "employee_record".||
|**team**|[Team](#team)|Team information object with members array.||
|**tenant**|str|Organization identifier.<br />Examples: "RetailCorp", "ClimateQuantumInc".||
|**version**|str|Current version of the data product.<br />Not required by the standard, but highly recommended.||
#### Examples

```
customer = DataProduct {
    id = "fbe8d147-28db-4f1d-bedf-a3fe9f458427"
    name = "Customer Data Product"
    version = "1.0.0"
    status = "draft"
    domain = "seller"
    tenant = "RetailCorp"

    description = Description {
        purpose = "Enterprise view of a customer."
        limitations = "No known limitations."
        usage = "Check the various artefacts for their own description."
    }

    inputPorts = [
        InputPort {
            name = "payments"
            version = "1.0.0"
            contractId = "dbb7b1eb-7628-436e-8914-2a00638ba6db"
        }
    ]

    outputPorts = [
        OutputPort {
            name = "rawtransactions"
            description = "Raw Transactions"
            $type = "tables"
            version = "1.0.0"
            contractId = "c2798941-1b7e-4b03-9e0d-955b1a872b32"
        }
    ]

    tags = ["customer"]
    productCreatedTs = "2023-01-15T10:30:00Z"
}
```

### AuthoritativeCustomizable

Base object carrying the optional `customProperties` and `authoritativeDefinitions` properties. Extended by every ODPS element that upstream gives both blocks but no `tags`.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**authoritativeDefinitions**|[[AuthoritativeDefinition](#authoritativedefinition)]|List of links to sources that provide more details on the data product.<br />Examples: link to a business glossary, a transformation implementation, a tutorial, or a data catalog.||
|**customProperties**|[[CustomProperty](#customproperty)]|A list of key/value pairs for custom properties.||
### AuthoritativeDefinition

A type/link pair for authoritative definitions. They allow to delegate the definition to a third party system like an enterprise catalog, repository, etc. The structure describing "Authoritative Definitions" is shared between all Bitol standards.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**description**|str|Optional description.||
|**type** `required`|str|Type of definition for authority.<br />At the root level, a type can also be `canonicalUrl` to indicate a reference to the data product&#39;s latest version.<br />Examples: "businessDefinition", "transformationImplementation", "videoTutorial", "tutorial", "implementation".||
|**url** `required`|str|URL to the authority.||
#### Examples

```
businessDefinition = AuthoritativeDefinition {
    $type = "businessDefinition"
    url = "https://glossary.enkinex.example/customer"
    description = "Business definition for the customer data product."
}

videoTutorial = AuthoritativeDefinition {
    $type = "videoTutorial"
    url = "https://videos.enkinex.example/customer-data-product"
    description = "Discover what a data product is."
}

odpsVersion = AuthoritativeDefinition {
    $type = "canonicalUrl"
    url = "https://github.com/bitol-io/open-data-product-standard/blob/main/docs/examples/customer-data-product.odps.yaml"
    description = "Data product's latest version."
}
```

### CustomProperty

This section covers custom properties you can use to add non-standard properties. This block is available in many sections of the standard.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**description**|str|Optional description.||
|**property** `required`|str|The name of the key.<br />Names should be in camel case, the same as if they were permanent properties in the contract.||
|**value** `required`|any|The value of the key. It can be a scalar, a list, or a map.||
#### Examples

```
transactionsVersion = CustomProperty {
    property = "transactionsVersion"
    value = "1.1.0"
}

stakeholderTeams = CustomProperty {
    property = "stakeholderTeams"
    value = ["analytics", "platform", "compliance"]
    description = "Teams consuming this data product."
}
```

### Description

Object containing the data product descriptions.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**authoritativeDefinitions**|[[AuthoritativeDefinition](#authoritativedefinition)]|List of links to sources that provide more details on the data product.<br />Examples: link to a business glossary, a transformation implementation, a tutorial, or a data catalog.||
|**customProperties**|[[CustomProperty](#customproperty)]|A list of key/value pairs for custom properties.||
|**limitations**|str|Technical, compliance, and legal limitations for data use.||
|**purpose**|str|Intended purpose for the provided data.||
|**usage**|str|Recommended usage of the data.||
#### Examples

```
description = Description {
    purpose = "Enterprise view of a customer."
    limitations = "No known limitations."
    usage = "Check the various artefacts for their own description."
    customProperties = [
        CustomProperty {
            property = "reviewedBy"
            value = "data-governance-team"
        }
    ]
}
```

### TagsDiscoverable

Base object carrying the optional properties shared by discoverable ODPS elements: `tags`, `customProperties` and `authoritativeDefinitions`.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**authoritativeDefinitions**|[[AuthoritativeDefinition](#authoritativedefinition)]|List of links to sources that provide more details on the data product.<br />Examples: link to a business glossary, a transformation implementation, a tutorial, or a data catalog.||
|**customProperties**|[[CustomProperty](#customproperty)]|A list of key/value pairs for custom properties.||
|**tags**|[str]|A list of tags that may be assigned to the elements (object or property).<br />The tags keyword may appear at any level.<br />Tags may be used to better categorize an element.<br />Examples: "finance", "sensitive", "employee_record".||
### ManagementPort

A management port defining an access point for managing the data product.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**authoritativeDefinitions**|[[AuthoritativeDefinition](#authoritativedefinition)]|List of links to sources that provide more details on the data product.<br />Examples: link to a business glossary, a transformation implementation, a tutorial, or a data catalog.||
|**channel**|str|Channel to communicate with the data product.||
|**content** `required`|str|The kind of management capability the endpoint exposes.<br />Examples: "discoverability", "observability", "control", "dictionary".||
|**customProperties**|[[CustomProperty](#customproperty)]|A list of key/value pairs for custom properties.||
|**description**|str|Purpose and usage of the endpoint.||
|**name** `required`|str|Endpoint identifier or unique name.||
|**tags**|[str]|A list of tags that may be assigned to the elements (object or property).<br />The tags keyword may appear at any level.<br />Tags may be used to better categorize an element.<br />Examples: "finance", "sensitive", "employee_record".||
|**type**|str|Transport used to reach the endpoint.<br />Examples: "rest", "topic".|"rest"|
|**url**|str|URL to access the endpoint.||
#### Examples

```
catalogDiscovery = ManagementPort {
    name = "catalog-discovery"
    content = "discoverability"
    $type = "rest"
    url = "https://api.enkinex.example/catalog"
    description = "Catalog discovery endpoint."
}

dictionaryUpdates = ManagementPort {
    name = "tpc-dict-update"
    content = "dictionary"
    $type = "topic"
    channel = "tpc-dict-update"
    description = "Kafka topic for dictionary updates."
}
```

### Sbom

Software Bill of Materials (SBOM) for an output port version. The SBOM can/should be at the version level.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**type**|str|Type of SBOM.<br />Upstream documents `external` as the default and, so far, the only value it defines.|"external"|
|**url** `required`|str|URL to download the Software Bill of Materials.||
#### Examples

```
externalSbom = Sbom {
    $type = "external"
    url = "https://sbom.enkinex.example/rawtransactions.json"
}
```

### InputContract

A dependency of an output port on a data contract, listed under `OutputPort.inputContracts`.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**id** `required`|str|Contract ID of the dependency, also written `contractId` upstream.||
|**version** `required`|str|Version of the input contract.||
#### Examples

```
payments = InputContract {
    id = "dbb7b1eb-7628-436e-8914-2a00638ba6db"
    version = "2.0.0"
}
```

### InputPort

An input port describing what the data product expects to consume. You need at least one, as a data product needs to get data somewhere.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**authoritativeDefinitions**|[[AuthoritativeDefinition](#authoritativedefinition)]|List of links to sources that provide more details on the data product.<br />Examples: link to a business glossary, a transformation implementation, a tutorial, or a data catalog.||
|**contractId** `required`|str|Contract ID for the input port.||
|**customProperties**|[[CustomProperty](#customproperty)]|A list of key/value pairs for custom properties.||
|**name** `required`|str|Name of the input port.||
|**tags**|[str]|A list of tags that may be assigned to the elements (object or property).<br />The tags keyword may appear at any level.<br />Tags may be used to better categorize an element.<br />Examples: "finance", "sensitive", "employee_record".||
|**version** `required`|str|Version of the input port.<br />The combination of the name and version is the key.||
#### Examples

```
payments = InputPort {
    name = "payments"
    version = "1.0.0"
    contractId = "dbb7b1eb-7628-436e-8914-2a00638ba6db"
}

onlineTransactions = InputPort {
    name = "onlinetransactions"
    version = "1.1.0"
    contractId = "ec2a112d-5cfe-49f3-8760-f9cfb4597547"
    tags = ["transactions"]
    customProperties = [
        CustomProperty {
            property = "transactionsVersion"
            value = "1.1.0"
        }
    ]
}
```

### OutputPort

An output port describing what the data product promises to deliver. You need at least one, as a data product without output is useless.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**authoritativeDefinitions**|[[AuthoritativeDefinition](#authoritativedefinition)]|List of links to sources that provide more details on the data product.<br />Examples: link to a business glossary, a transformation implementation, a tutorial, or a data catalog.||
|**contractId**|str|Contract ID for the output port.||
|**customProperties**|[[CustomProperty](#customproperty)]|A list of key/value pairs for custom properties.||
|**description**|str|Human readable short description of the output port.||
|**inputContracts**|[[InputContract](#inputcontract)]|Dependencies of this output port, expressed as input contracts.||
|**name** `required`|str|Name of the output port.||
|**sbom**|[[Sbom](#sbom)]|The Software Bill of Materials, which can/should be at the version level.||
|**tags**|[str]|A list of tags that may be assigned to the elements (object or property).<br />The tags keyword may appear at any level.<br />Tags may be used to better categorize an element.<br />Examples: "finance", "sensitive", "employee_record".||
|**type**|str|There can be different types of output ports, each automated and handled differently.<br />Here you can indicate the type.<br />Upstream defines no value list; `tables` is the value used throughout its reference examples.||
|**version** `required`|str|For each version, a different instance of the output port is listed.<br />The combination of the name and version is the key.||
#### Examples

```
consolidatedTransactions = OutputPort {
    name = "consolidatedtransactions"
    description = "Consolidated transactions"
    $type = "tables"
    version = "1.0.0"
    contractId = "a44978be-1fe0-4226-b840-1b715bc25c63"
}

rawTransactions = OutputPort {
    name = "rawtransactions"
    description = "Raw Transactions"
    $type = "tables"
    version = "2.0.0"
    contractId = "c2798941-1b7e-4b03-9e0d-955b1a872b33"
    sbom = [
        Sbom {
            $type = "external"
            url = "https://sbom.enkinex.example/rawtransactions.json"
        }
    ]
    inputContracts = [
        InputContract {
            id = "dbb7b1eb-7628-436e-8914-2a00638ba6db"
            version = "2.0.0"
        }
    ]
}
```

### Support

Support and communication channels help consumers find help regarding their use of the data product. The structure describing "support and communication channels" is shared between all Bitol standards.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**authoritativeDefinitions**|[[AuthoritativeDefinition](#authoritativedefinition)]|List of links to sources that provide more details on the data product.<br />Examples: link to a business glossary, a transformation implementation, a tutorial, or a data catalog.||
|**channel** `required`|str|Channel name or identifier.||
|**customProperties**|[[CustomProperty](#customproperty)]|A list of key/value pairs for custom properties.||
|**description**|str|Description of the channel, free text.||
|**invitationUrl**|str|Some tools uses invitation URL for requesting or subscribing.<br />Follows the [URL scheme](https://en.wikipedia.org/wiki/URL#Syntax).||
|**scope**|str|The channel scope.<br />Examples: "interactive", "announcements", "issues".||
|**tags**|[str]|A list of tags that may be assigned to the elements (object or property).<br />The tags keyword may appear at any level.<br />Tags may be used to better categorize an element.<br />Examples: "finance", "sensitive", "employee_record".||
|**tool**|str|Name of the tool.<br />Examples: "email", "slack", "teams", "discord", "ticket", "other".||
|**url** `required`|str|Access URL using normal [URL scheme](https://en.wikipedia.org/wiki/URL#Syntax) (https, mailto, etc.).||
#### Examples

```
slack = Support {
    channel = "Data Team Slack"
    url = "https://enkinex.slack.com/archives/C1234567890"
    description = "Primary support channel for data product questions."
    tool = "slack"
    scope = "interactive"
    invitationUrl = "https://enkinex.slack.com/invite/DEF456"
}

email = Support {
    channel = "Email Support"
    url = "mailto:data-support@enkinex.example"
    description = "Email support for urgent issues."
    tool = "email"
    scope = "issues"
}
```

### Team

The team responsible for the data product.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**authoritativeDefinitions**|[[AuthoritativeDefinition](#authoritativedefinition)]|List of links to sources that provide more details on the data product.<br />Examples: link to a business glossary, a transformation implementation, a tutorial, or a data catalog.||
|**customProperties**|[[CustomProperty](#customproperty)]|A list of key/value pairs for custom properties.||
|**description**|str|Team description.||
|**members**|[[TeamMember](#teammember)]|List of members.||
|**name**|str|Team name.||
|**tags**|[str]|A list of tags that may be assigned to the elements (object or property).<br />The tags keyword may appear at any level.<br />Tags may be used to better categorize an element.<br />Examples: "finance", "sensitive", "employee_record".||
#### Examples

```
team = Team {
    name = "Data Team"
    description = "The Data Team is responsible for the data product."
    tags = ["data", "team"]
    members = [
        TeamMember {
            username = "john.doe@enkinex.example"
            name = "John Doe"
            role = "owner"
            dateIn = "2023-01-15"
        },
        TeamMember {
            username = "jane.smith@enkinex.example"
            name = "Jane Smith"
            role = "data steward"
            dateIn = "2023-02-01"
        }
    ]
}
```

### TeamMember

A member of the team responsible for the data product. The structure describing "team" is shared between all Bitol standards, matching RFC 0016.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**authoritativeDefinitions**|[[AuthoritativeDefinition](#authoritativedefinition)]|List of links to sources that provide more details on the data product.<br />Examples: link to a business glossary, a transformation implementation, a tutorial, or a data catalog.||
|**customProperties**|[[CustomProperty](#customproperty)]|A list of key/value pairs for custom properties.||
|**dateIn**|str|The date when the user joined the team, using the ISO 8601 date format (YYYY-MM-DD).||
|**dateOut**|str|The date when the user ceased to be part of the team, using the ISO 8601 date format (YYYY-MM-DD).||
|**description**|str|The user&#39;s description.||
|**name**|str|The user&#39;s name.||
|**replacedByUsername**|str|The username of the user who replaced the previous user.<br />Requires `dateOut` to be set.||
|**role**|str|The user&#39;s job role.<br />There is no limit on the role.<br />Examples: "owner", "data steward".||
|**tags**|[str]|A list of tags that may be assigned to the elements (object or property).<br />The tags keyword may appear at any level.<br />Tags may be used to better categorize an element.<br />Examples: "finance", "sensitive", "employee_record".||
|**username** `required`|str|The user&#39;s username or email.||
#### Examples

```
owner = TeamMember {
    username = "john.doe@enkinex.example"
    name = "John Doe"
    description = "Data Product Owner"
    role = "owner"
    dateIn = "2023-01-15"
}

formerSteward = TeamMember {
    username = "jane.smith@enkinex.example"
    name = "Jane Smith"
    role = "data steward"
    dateIn = "2023-02-01"
    dateOut = "2024-05-31"
    replacedByUsername = "kim.lee@enkinex.example"
}
```

<!-- Auto generated by kcl-doc tool, please do not edit. -->
