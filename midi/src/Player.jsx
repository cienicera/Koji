import React, {useState, useEffect, useRef} from 'react'
import {
    styled, Typography, Slider,
    Paper, Stack, Box
} from '@mui/material';
import Search from './music/Search';



// #region ------------ ICONS ---------
import VolumeDownIcon from '@mui/icons-material/VolumeDown';
import VolumeUpIcon from '@mui/icons-material/VolumeUp';
import VolumeOffIcon from '@mui/icons-material/VolumeOff';
import VolumeMuteIcon from '@mui/icons-material/VolumeMute';

import PauseIcon from '@mui/icons-material/Pause';
import FastRewindIcon from '@mui/icons-material/FastRewind';
import FastForwardIcon from '@mui/icons-material/FastForward';
import PlayArrowIcon from '@mui/icons-material/PlayArrow';
import SkipNextIcon from '@mui/icons-material/SkipNext';
import SkipPreviousIcon from '@mui/icons-material/SkipPrevious';
// #endregion ------------ ICONS ---------

// #region ------- Tracts -------------------------------------------------------
import fade from './music/As You Fade Away - NEFFEX.mp3'
import enough from './music/Enough - NEFFEX.mp3'
import immortal from './music/Immortal - NEFFEX.mp3';
import playDead from './music/Play Dead - NEFFEX.mp3';
import winning from './music/Winning - NEFFEX.mp3';
// #endregion ---------------------------------------------------------------

// #region -------- Styled Components -----------------------------------------
const Div = styled('div')(({theme}) => ({
    backgroundColor: 'black',
    height:'100vh',
    width:'100vw',
    paddingTop: theme.spacing(6)
}))

const CustomPaper = styled(Paper)(({theme}) => ({
    backgroundColor: '#4c4c4c',
    marginLeft: theme.spacing(6),
    marginRight: theme.spacing(6),
    padding: theme.spacing(2)
}))

const PSlider = styled(Slider)(({theme, ...props}) => ({
    color: 'lime',
    height: 2,
    '&:hover': {
        cursor: 'auto',
    },
    '& .MuiSlider-thumb': {
        width: '13px',
        height: '13px',
        display: props.thumbless ? 'none' : 'block',
    }
}))
// #endregion ---------------------------------------------------------------


const playlist = [fade, enough, immortal, playDead, winning];


export default function Player() {
    const audioPlayer = useRef()

    const [index, setIndex] = useState(0);

    const [currentSong] = useState(playlist[index]);

    const [isPlaying, setIsPlaying] = useState(false);
    const [volume, setVolume] = useState(30);
    const [mute, setMute] = useState(false);

    const [elapsed, setElapsed] = useState(0);
    const [duration, setDuration] = useState(0);

    useEffect(() => {
        if(audioPlayer){
            audioPlayer.current.volume = volume / 100;
        }

        
        if(isPlaying){
            setInterval(() => {
                const _duration = Math.floor(audioPlayer?.current?.duration);
                const _elapsed = Math.floor(audioPlayer?.current?.currentTime);

                setDuration(_duration);
                setElapsed(_elapsed);
            }, 100);
        }

    }, [
        volume, isPlaying
    ]);

    function formatTime(time) {
        if(time && !isNaN(time)){
            const minutes = Math.floor(time / 60) < 10 ? `0${Math.floor(time / 60)}` : Math.floor(time / 60);
            const seconds = Math.floor(time % 60) < 10 ? `0${Math.floor(time % 60)}` : Math.floor(time % 60);

            return `${minutes}:${seconds}`;
        }
        return '00:00';
    }

    const togglePlay = () => {
        if(!isPlaying) {
            audioPlayer.current.play()
        }else {
            audioPlayer.current.pause()
        }
        setIsPlaying(prev => !prev)
    }

    const toggleForward = () => {
        audioPlayer.current.currentTime += 10;
    }

    const toggleBackward = () => {
        audioPlayer.current.currentTime -= 10;
    }

    const toggleSkipForward = () => {
        if(index >= playlist.length - 1) {
            setIndex(0);
            audioPlayer.current.src = playlist[0];
            audioPlayer.current.play();
        } else {
            setIndex(prev => prev + 1);
            audioPlayer.current.src = playlist[index + 1];
            audioPlayer.current.play();
        }
    }

    const toggleSkipBackward = () => {
        if(index > 0) {
            setIndex(prev => prev - 1);
            audioPlayer.current.src = playlist[index - 1];
            audioPlayer.current.play();
        }
    }
    
    function VolumeBtns(){
        return mute
            ? <VolumeOffIcon sx={{color: 'lime', '&:hover': {color: 'white'}}} onClick={() => setMute(!mute)} />
            : volume <= 20 ? <VolumeMuteIcon sx={{color: 'lime', '&:hover': {color: 'white'}}} onClick={() => setMute(!mute)} />
            : volume <= 75 ? <VolumeDownIcon sx={{color: 'lime', '&:hover': {color: 'white'}}} onClick={() => setMute(!mute)} />
            : <VolumeUpIcon sx={{color: 'lime', '&:hover': {color: 'white'}}} onClick={() => setMute(!mute)} />
    }

    return (
        <>
      
            <Div>
            <Search />

            <audio src={currentSong} ref={audioPlayer} muted={mute} />
            <CustomPaper>
                <Box sx={{display: 'flex', justifyContent: 'space-between'}}>
                    <Stack direction='row' spacing={1} 
                        sx={{
                            display: 'flex',
                            justifyContent: 'flex-start',
                            width: '25%',
                            alignItems: 'center'
                        }}
                    >
                        <VolumeBtns  />

                        <PSlider min={0} max={100} value={volume}
                            onChange={(e, v) => setVolume(v)}
                        />
                    </Stack>

                    <Stack direction='row' spacing={1}
                        sx={{
                            display: 'flex',
                            width: '40%',
                            alignItems: 'center'
                        }}>
                        <SkipPreviousIcon 
                            sx={{
                                color: 'lime', 
                                '&:hover': {color: 'white'}
                            }} 
                            onClick={toggleSkipBackward} disabled={true}/>
                        <FastRewindIcon sx={{color: 'lime', '&:hover': {color: 'white'}}} onClick={toggleBackward}/>

                        {!isPlaying
                            ?   <PlayArrowIcon fontSize={'large'} sx={{color: 'lime', '&:hover': {color: 'white'}}} onClick={togglePlay}/>
                            :   <PauseIcon fontSize={'large'} sx={{color: 'lime', '&:hover': {color: 'white'}}} onClick={togglePlay}/>
                        }


                        <FastForwardIcon sx={{color: 'lime', '&:hover': {color: 'white'}}} onClick={toggleForward} />
                        <SkipNextIcon sx={{color: 'lime', '&:hover': {color: 'white'}}} onClick={toggleSkipForward}/>
                    </Stack>

                    <Stack sx={{
                        display: 'flex',
                        justifyContent: 'flex-end',
                    }} />
                </Box>
                <Stack spacing={1} direction='row' sx={{
                    display: 'flex',
                    alignItems: 'center'
                }}>
                    <Typography sx={{color: 'lime'}}>{formatTime(elapsed)}</Typography>
                    <PSlider thumbless value={elapsed} max={duration} />
                    <Typography sx={{color: 'lime'}}>{formatTime(duration - elapsed)}</Typography>
                </Stack>
            </CustomPaper>
            </Div>
            </>
    )
}
