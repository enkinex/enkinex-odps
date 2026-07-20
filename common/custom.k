schema AuthoritativeCustomizable:
    """
    Base schema providing the common extension points shared across ODPS
    elements: custom properties and authoritative definitions.

    Attributes
    ----------
    customProperties : [CustomProperty], optional
        A list of key/value pairs for custom properties.
    authoritativeDefinitions : [AuthoritativeDefinition], optional
        List of links to sources that provide more details on the data contract.
    """
    customProperties?: [CustomProperty]
    authoritativeDefinitions?: [AuthoritativeDefinition]

