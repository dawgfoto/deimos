import deimos.sndfile;
import std.exception, std.stdio, std.string : toStringz;

int main(string[] args)
{
    if (args.length != 3)
    {
        stderr.writeln("usage: process <infile> <outfile>");
        return 1;
    }

    SF_INFO info;
    auto infile = enforce(sf_open(toStringz(args[1]), SFM_READ, &info));
    auto outfile = enforce(sf_open(toStringz(args[2]), SFM_WRITE, &info));

    auto buf = new double[](1024 * info.channels);

    size_t nframes;
    while ((nframes = sf_readf_double(infile, buf.ptr, 1024)) > 0)
    {
        process(buf[0 .. nframes * info.channels], info.channels);
        sf_writef_double(outfile, buf.ptr, nframes);
    }

    return 0;
}

void process(double[] data, size_t nchannels)
{
    // simple gain of -6dB on interleaved data
    data[] *= 0.5;
}
