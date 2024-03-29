import React, {useState, useRef, useEffect} from 'react'
import {
    styled, Typography, Slider, LinearProgress,
    Paper as unStyledPaper, Stack, Box
} from '@mui/material'

import VolumeDownIcon from '@mui/icons-material/VolumeDown';
import VolumeUpIcon from '@mui/icons-material/VolumeUp';
import VolumeOffIcon from '@mui/icons-material/VolumeOff';
import VolumeMuteIcon from '@mui/icons-material/VolumeMute';

import IosShareIcon from '@mui/icons-material/IosShare';
import PauseIcon from '@mui/icons-material/Pause';
import FastRewindIcon from '@mui/icons-material/FastRewind';
import FastForwardIcon from '@mui/icons-material/FastForward';
import PlayArrowIcon from '@mui/icons-material/PlayArrow';
import SkipNextIcon from '@mui/icons-material/SkipNext';
import SkipPreviousIcon from '@mui/icons-material/SkipPrevious';

import fade from './music/As You Fade Away - NEFFEX.mp3'
import enough from './music/Enough - NEFFEX.mp3'

const songs = [fade, enough]


const Div = styled('div')(({theme}) => ({
    backgroundColor: 'black',
    height:'100vh',
    width:'100vw',
    paddingTop: theme.spacing(6)
}))

const Paper = styled(unStyledPaper)(({theme}) => ({
    backgroundColor: '#4c4c4c',
    marginLeft: theme.spacing(6),
    marginRight: theme.spacing(6),
    padding: theme.spacing(2)
}))

const PSlider = styled(Slider)(({theme, ...props}) => ({
    color: 'silver',
    height: 2,
    '& .MuiSlider-thumb': {
        width: '13px',
        height: '13px',
        display: props.thumbless ? 'none' : 'block',
    },
    '&:hover': {
        cursor: 'auto',
    }
}))

export default function Demo() {
    const player = useRef()
    const progressBar = useRef()

    const [index, setIndex] = useState(1);
    const [isPlaying, setIsPlaying] = useState(false);
    const [elapsed, setElapsed] = useState(0)
    const [duration, setDuration] = useState(0)
    const [volume, setVolume] = useState(30)
    const [mute, setMute] = useState(false)
    const [currentSong] = useState(songs[index])

    useEffect(() => {
        
        if(isPlaying) {
            setInterval(() => {
                const duration = Math.floor(player?.current?.duration)
                const elapsedTime = Math.floor(player?.current?.currentTime)

                setDuration(duration)
                setElapsed(elapsedTime)

                if(elapsedTime === duration){
                    setIsPlaying(false)
                    player.current.stop()
                }
            }, 100);
        }

        if(player){
            player.current.volume = volume / 100
        }

    },[
        player?.current?.loadedmetadata, 
        player?.current?.readyState, 
        isPlaying, volume 
    ])

    const calculateTime = (value) => {
        const minutes = Math.floor(value / 60) < 10 ? `0${Math.floor(value / 60)}` : Math.floor(value / 60)

        const seconds = Math.floor(value % 60) < 10 ? `0${Math.floor(value % 60)}` : Math.floor(value % 60)

        return `${minutes}:${seconds}`
    }

    const togglePausePlay = () => {
        const prevVal = isPlaying;
        setIsPlaying(!prevVal)

        if(!prevVal){
            player.current.play()
        } else {
            player.current.pause()
        }
    }
    const handleForward = () => {
        player.current.currentTime += 10
    }

    const handleReverse = () => {
        player.current.currentTime -= 10
    }

    const togglePrev = () =>{
        if(index > 0){
            setIndex(prev => prev - 1)
            player.current.src = songs[index - 1]
            player.current.play()
        }
    }

    const toggleNext = () =>{
        //player.current.stop()
        if(index >= songs.length - 1){
            setIndex(0)
            player.current.src = songs[0]
            player.current.play()
        } else {
            setIndex(prev => prev + 1)
            player.current.src = songs[index + 1]
            player.current.play()
        }
    }

    function VolumeBtn () {
        return mute 
            ? <VolumeOffIcon sx={{color: 'silver', '&:hover': {color:'white'}}} onClick={() => setMute(!mute)}/> 
            : volume <= 20 ? <VolumeMuteIcon sx={{color: 'silver', '&:hover': {color:'white'}}} onClick={() => setMute(!mute)}/> 
            : volume <= 75 ? <VolumeDownIcon sx={{color: 'silver', '&:hover': {color:'white'}}} onClick={() => setMute(!mute)}/> 
            : <VolumeUpIcon sx={{color: 'silver', '&:hover': {color:'white'}}} onClick={() => setMute(!mute)}/>
    }
    return (
        <Div>
            <Paper>
                <Box sx={{display: 'flex', justifyContent: 'space-between'}}>
                    <audio src={currentSong} ref={player} muted={mute}/>

                    <Stack direction='row' spacing={1} sx={{
                        display: 'flex', 
                        justifyContent: 'flex-start', 
                        width: '25%',
                        alignItems: 'center'
                    }}>
                        <VolumeBtn />
                        <Slider 
                            min={0} value={volume} max={100} 
                            onChange={e => setVolume(e.target.value)} 
                        />
                    </Stack>

                    <Stack direction='row' spacing={1} sx={{
                        display: 'flex', 
                        //justifyContent: 'center', 
                        width: '40%',
                        alignItems: 'center'
                    }}>
                        <SkipPreviousIcon 
                            sx={{color: 'silver', '&:hover': {color:'white'}}}
                            onClick={togglePrev} 
                        />
                        <FastRewindIcon 
                            sx={{color: 'silver', '&:hover': {color:'white'}}}
                            onClick={handleReverse} 
                        />
                        {!isPlaying 
                            ?   <PlayArrowIcon 
                                    sx={{color: 'silver', '&:hover': {color:'white'}}} 
                                    fontSize={'large'} 
                                    onClick={togglePausePlay}
                                />
                            :   <PauseIcon 
                                    sx={{color: 'silver', '&:hover': {color:'white'}}} 
                                    fontSize={'large'} 
                                    onClick={togglePausePlay}
                                />
                        }
                        <FastForwardIcon 
                            sx={{color: 'silver', '&:hover': {color:'white'}}} 
                            onClick={handleForward}
                        />
                        <SkipNextIcon 
                            sx={{color: 'silver', '&:hover': {color:'white'}}} 
                            onClick={toggleNext}
                        />
                    </Stack>
                    <Box sx={{
                        display: 'flex', 
                        //width: '30%',
                        justifyContent: 'flex-end', 
                        alignItems: 'center'
                    }}>
                        <IosShareIcon sx={{color: 'silver'}} />
                    </Box>
                </Box>
                <Stack spacing={1} direction='row' sx={{
                    display: 'flex', 
                    justifyContent: 'flex-end', 
                    alignItems: 'center'
                }}>
                    <Typography sx={{color: 'silver'}}>{calculateTime(elapsed)}</Typography>
                    <PSlider  value={elapsed} max={duration} thumbless ref={progressBar} />
                    <Typography sx={{color: 'silver'}}>{calculateTime(duration - elapsed)}</Typography>
                </Stack>
            </Paper>
        </Div>
    )
}

