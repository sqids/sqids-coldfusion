component namespace="Sqids" accessors=true
{
    property name ="alphabet" type=string setter=false;
    property name ="minLength" type=numeric setter=false;
    property name ="blocklist" type=array setter=false;

    public SqidsOptions function init(string alphabet, string minLength, array blocklist)
    {
        variables.alphabet = isNull(arguments.alphabet)
                ? "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                : arguments.alphabet;

        variables.minLength = isNull(arguments.minLength)
                ? 0
                : arguments.minLength;

        variables.blocklist = isNull(arguments.blocklist)
                ? deserializeJSON(fileRead(getCanonicalPath(getDirectoryFromPath(getCurrentTemplatePath()) & "/blocklist.json")))
                : arguments.blocklist;

        return this;
    }
}
